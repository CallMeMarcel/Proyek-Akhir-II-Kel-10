import 'package:del_cafeshop/common/widgets/appbar/appbar.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/features/shop/controlles/cart_controller.dart';
import 'package:del_cafeshop/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:del_cafeshop/features/shop/screens/checkout/checkout.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with TickerProviderStateMixin {
  final cartController = Get.put(CartController());
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  // Controller untuk show/hide deskripsi
  final RxBool _showDescription = true.obs;

  // Orange color scheme
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color lightOrange = Color(0xFFFFB085);
  static const Color darkOrange = Color(0xFFE55A2B);
  static const Color accentOrange = Color(0xFFFFA366);

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
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

    // Initialize animations
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: TAppbar(
        showBackArrow: true,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Iconsax.shopping_cart,
                color: primaryOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text('My Cart', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(width: 8),
            Obx(() => cartController.cartItems.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${cartController.cartItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
      body: Obx(() {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: cartController.cartItems.isEmpty
              ? _buildEmptyCart(context)
              : _buildCartContent(context),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cartController.cartItems.isEmpty) return const SizedBox.shrink();
        
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _slideController,
            curve: Curves.easeOutCubic,
          )),
          child: _buildBottomCheckout(context),
        );
      }),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Empty cart illustration
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryOrange.withOpacity(0.2),
                        lightOrange.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.shopping_bag,
                    size: 60,
                    color: primaryOrange.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                Text(
                  'Your cart is empty',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: darkOrange,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  'Looks like you haven\'t added\nanything to your cart yet',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                Container(
                  width: double.infinity,
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Iconsax.shop),
                    label: const Text('Start Shopping'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      shadowColor: primaryOrange.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Cart summary header dengan toggle deskripsi
            Container(
              margin: const EdgeInsets.all(TSizes.defaultSpace),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryOrange.withOpacity(0.15),
                    lightOrange.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryOrange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Header utama
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryOrange, darkOrange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: primaryOrange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Iconsax.receipt_item,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Summary',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: darkOrange,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                '${cartController.cartItems.length} items in your cart',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              )),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.withOpacity(0.2),
                                Colors.green.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.discount_shape,
                                size: 14,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'FREE DELIVERY',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Toggle button untuk deskripsi
                  GestureDetector(
                    onTap: () {
                      _showDescription.value = !_showDescription.value;
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryOrange.withOpacity(0.1),
                            accentOrange.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.eye,
                            size: 16,
                            color: primaryOrange,
                          ),
                          const SizedBox(width: 8),
                          Obx(() => Text(
                            _showDescription.value ? 'Hide Description' : 'Show Description',
                            style: TextStyle(
                              color: primaryOrange,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )),
                          const SizedBox(width: 8),
                          Obx(() => AnimatedRotation(
                            turns: _showDescription.value ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Iconsax.arrow_down_1,
                              size: 16,
                              color: primaryOrange,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Cart items dengan toggle deskripsi
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                child: EnhancedCartItems(
                  showDescription: _showDescription,
                  cartController: cartController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCheckout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkout button
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Validasi cart tidak kosong sebelum checkout
                  if (cartController.cartItems.isNotEmpty) {
                    // Add button press animation
                    _scaleController.reset();
                    _scaleController.forward();
                    
                    // Navigate to checkout with cart data
                    Get.to(() => const CheckoutScreen());
                  } else {
                    Get.snackbar(
                      'Cart Empty',
                      'Please add items to your cart before checkout',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withOpacity(0.1),
                      colorText: Colors.red,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  shadowColor: primaryOrange.withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Iconsax.card),
                    const SizedBox(width: 12),
                    const Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Iconsax.arrow_right_3, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return 'Rp${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}

class ProductPrice extends StatelessWidget {
  final String price;
  final bool isLarge;

  const ProductPrice({
    super.key,
    required this.price,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      style: isLarge
          ? Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF6B35), // Primary orange
            )
          : Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE55A2B), // Dark orange
            ),
    );
  }
}

// Enhanced CartItems widget dengan show/hide description dan fungsi yang lengkap
class EnhancedCartItems extends StatelessWidget {
  final RxBool showDescription;
  final CartController cartController;
  
  // Orange color scheme
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color lightOrange = Color(0xFFFFB085);
  static const Color darkOrange = Color(0xFFE55A2B);
  static const Color accentOrange = Color(0xFFFFA366);
  
  const EnhancedCartItems({
    super.key,
    required this.showDescription,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.separated(
        itemCount: cartController.cartItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = cartController.cartItems[index];
          return _buildCartItem(context, item, index);
        },
      );
    });
  }

  Widget _buildCartItem(BuildContext context, dynamic item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: primaryOrange.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // Item utama
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        primaryOrange.withOpacity(0.15),
                        lightOrange.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: item.image != null
                      ? Image.network(
                          item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Iconsax.image,
                              color: primaryOrange,
                              size: 32,
                            );
                          },
                        )
                      : Icon(
                          Iconsax.image,
                          color: primaryOrange,
                          size: 32,
                        ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        item.title ?? 'Product Name',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Product price
                      Text(
                        _formatPrice(item.price ?? 0),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Quantity controls
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryOrange.withOpacity(0.15),
                                  accentOrange.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: primaryOrange.withOpacity(0.2),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _decreaseQuantity(item);
                                  },
                                  icon: Icon(
                                    Iconsax.minus, 
                                    size: 16,
                                    color: primaryOrange,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Obx(() => Text(
                                    '${cartController.getQuantityForProduct(item.id ?? '')}',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: darkOrange,
                                    ),
                                  )),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _increaseQuantity(item);
                                  },
                                  icon: Icon(
                                    Iconsax.add, 
                                    size: 16,
                                    color: primaryOrange,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Delete button
                          IconButton(
                            onPressed: () {
                              _showDeleteConfirmation(context, item);
                            },
                            icon: const Icon(Iconsax.trash, color: Colors.red),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Animated description section
          Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showDescription.value ? null : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: showDescription.value ? 1.0 : 0.0,
              child: showDescription.value
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryOrange.withOpacity(0.08),
                              lightOrange.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: primaryOrange.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.note_text,
                                  size: 16,
                                  color: primaryOrange,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Description',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryOrange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.description ?? 'No description available for this product.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          )),
        ],
      ),
    );
  }

  // Fungsi untuk menambah quantity
  void _increaseQuantity(dynamic item) {
    cartController.addToCart(item);
    
    // Show success feedback with orange theme
    Get.snackbar(
      'Updated',
      'Item quantity increased',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: primaryOrange.withOpacity(0.1),
      colorText: primaryOrange,
      duration: const Duration(seconds: 1),
    );
  }

  // Fungsi untuk mengurangi quantity
  void _decreaseQuantity(dynamic item) {
    int currentQuantity = cartController.getQuantityForProduct(item.id ?? '');
    
    if (currentQuantity > 1) {
      cartController.decreaseQuantity(item);
      
      // Show success feedback
      Get.snackbar(
        'Updated',
        'Item quantity decreased',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: accentOrange.withOpacity(0.1),
        colorText: darkOrange,
        duration: const Duration(seconds: 1),
      );
    } else {
      // If quantity is 1, show confirmation dialog
      _showDeleteConfirmation(Get.context!, item);
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi delete
  void _showDeleteConfirmation(BuildContext context, dynamic item) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Iconsax.warning_2,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text('Remove Item'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "${item.title ?? 'this item'}" from your cart?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              cartController.removeFromCart(item);
              Get.back();
              
              // Show success feedback
              Get.snackbar(
                'Removed',
                '${item.title ?? 'Item'} removed from cart',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withOpacity(0.1),
                colorText: Colors.red,
                duration: const Duration(seconds: 2),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return 'Rp${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}