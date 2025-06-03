import 'package:del_cafeshop/common/widgets/appbar/appbar.dart';
import 'package:del_cafeshop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:del_cafeshop/common/widgets/success_screen/success_screen.dart';
import 'package:del_cafeshop/features/shop/controlles/cart_controller.dart';
import 'package:del_cafeshop/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:del_cafeshop/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:del_cafeshop/features/shop/screens/payments/payment.dart';
import 'package:del_cafeshop/navigation_menu.dart';
import 'package:del_cafeshop/utils/constants/api_constants.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';

Future<String?> createTransaction({
  required String orderId,
  required int amount,
  required String customerName,
}) async {
  final url = Uri.parse('${APIConstants.baseUrl}/admin/payment');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'orderId': orderId,
        'amount': amount,
        'customerName': customerName,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final snapToken = data['snapToken'];
      return snapToken;
    } else {
      print('Gagal membuat transaksi: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error creating transaction: $e');
    return null;
  }
}

Future<Map<String, String>?> sendOrderToBackend(int userId, List<Map<String, dynamic>> items) async {
  final url = Uri.parse('${APIConstants.baseUrl}/admin/orders');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'items': items,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final orderId = data['order_id'].toString();
      final token = data['token'].toString();
      print('Order created: $orderId with token: $token');
      return {
        'order_id': orderId,
        'token': token,
      };
    } else {
      print('Gagal membuat order: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error sending order: $e');
    return null;
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String selectedPaymentMethod = 'Midtrans';
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id') ?? 'Pengguna';
    final username = prefs.getString('username') ?? 'Email belum diatur';
    return {'id': id, 'username': username};
  }

  String _formatPrice(double price) {
    return 'Rp${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: dark ? TColors.dark : const Color(0xFFF8F9FA),
      appBar: TAppbar(
        showBackArrow: true,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Iconsax.shopping_cart,
                color: Colors.deepOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Checkout',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.black87,
                  ),
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      _buildProgressStep('1', 'Cart', true, true),
                      _buildProgressLine(true),
                      _buildProgressStep('2', 'Checkout', true, false),
                      _buildProgressLine(false),
                      _buildProgressStep('3', 'Payment', false, false),
                    ],
                  ),
                ),
                _buildAnimatedSection(
                  delay: 200,
                  child: Container(
                    decoration: BoxDecoration(
                      color: dark ? TColors.darkContainer : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.receipt_1,
                                color: Colors.deepOrange,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Order Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: dark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: CartItems(showAddRemoveButtons: false),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnimatedSection(
                  delay: 400,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: dark ? TColors.darkContainer : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.location,
                              color: Colors.deepOrange,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Delivery Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: dark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.shop,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pickup at Store',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      'Ready in 10-15 minutes',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnimatedSection(
                  delay: 600,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: dark ? TColors.darkContainer : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.card,
                              color: Colors.deepOrange,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Payment Method',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: dark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildPaymentOption(
                          'Midtrans',
                          'Digital Payment Gateway',
                          Iconsax.wallet,
                          Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        _buildPaymentOption(
                          'Cash',
                          'Pay at store',
                          Iconsax.money,
                          Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final total = cartController.totalHarga;
        final tax = total * 0.1;
        final finalTotal = total + tax;

        return ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: dark ? TColors.dark : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal'),
                            Text(_formatPrice(total)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tax (10%)'),
                            Text(_formatPrice(tax)),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _formatPrice(finalTotal),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isProcessing ? null : () => _processPayment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isProcessing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text('Processing...'),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.card, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Buy Now ${_formatPrice(finalTotal)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProgressStep(String number, String label, bool isActive, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green
                : isActive
                    ? Colors.deepOrange
                    : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    number,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.deepOrange : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, IconData icon, Color color) {
    final isSelected = selectedPaymentMethod == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.deepOrange : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.deepOrange : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Iconsax.tick_circle,
                color: Colors.deepOrange,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
  setState(() {
    isProcessing = true;
  });

  try {
    final cartController = Get.find<CartController>();
    final prefs = await SharedPreferences.getInstance();
    final userId = int.tryParse(prefs.getString('id') ?? '');
    final customerName = prefs.getString('username') ?? 'Pelanggan';

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Iconsax.warning_2, color: Colors.white),
              const SizedBox(width: 8),
              Text('User tidak ditemukan. Silakan login ulang.'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cartItems = cartController.cartItems.map((item) {
      return {
        'product_id': item.id,
        'product_name': item.name,
        'price': item.price,
        'quantity': cartController.getQuantityForProduct(item.id),
      };
    }).toList();

    final total = cartController.totalHarga;
    final tax = total * 0.1;
    final finalTotal = (total + tax).toInt();

    final orderData = await sendOrderToBackend(userId, cartItems);

    if (orderData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Iconsax.close_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Gagal membuat order'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final token = orderData['token'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.tick_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Order berhasil!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      ),
    );

    if (selectedPaymentMethod == 'Cash') {
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } else {
      String? snapToken = await createTransaction(
        orderId: orderData['order_id'] ?? '',
        amount: finalTotal,
        customerName: customerName,
      );
  
      if (snapToken != null) {
        final paymentResult = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentPage(snapToken: snapToken),
          ),
        );
        print('Payment Result: $paymentResult');
        if (paymentResult != null && paymentResult is Map<String, dynamic>) {
          final status = paymentResult['status']?.toString().toLowerCase();
          print('Status: $status');
          switch (status) {
            case 'success':
              cartController.clearCart();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => SuccessScreen(
                    image: TImages.emailVerification1,
                    title: 'Pembayaran Berhasil!',
                    subTitle: 'Pesanan Anda sedang diproses.',
                    
                    onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const NavigationMenu()),
                    (route) => false,
                  );
                }, 
                orderId: int.parse(orderData['order_id'] ?? '0'), 
                token: token ?? '',

                  ),
                ),
                (route) => false,
              );
              break;
            case 'pending':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Iconsax.clock, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('Pembayaran tertunda. Token: $token'),
                    ],
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
              break;
            case 'error':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Iconsax.close_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('Pembayaran gagal. Silakan coba lagi.'),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              break;
            case 'close':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Iconsax.close_square, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('Pembayaran dibatalkan.'),
                    ],
                  ),
                  backgroundColor: Colors.grey,
                ),
              );
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Iconsax.warning_2, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('Status pembayaran tidak dikenal.'),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Iconsax.close_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Gagal memproses pembayaran'),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Iconsax.close_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('Gagal memulai pembayaran'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } finally {
    setState(() {
      isProcessing = false;
    });
  }
}
}