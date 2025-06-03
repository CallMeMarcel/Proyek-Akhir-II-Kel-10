import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:del_cafeshop/data/models/order.dart';
import 'package:del_cafeshop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _progressController;
  
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

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
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Initialize animations
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
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
    _progressController.forward();
    
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final totalPrice = widget.order.products.fold<int>(
      0,
      (sum, product) => sum + (product.price * product.quantity),
    );

    final statusColor = _getStatusColor(widget.order.status);
    final statusIcon = _getStatusIcon(widget.order.status);
    final progressValue = _getProgressValue(widget.order.status);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      
      // Enhanced AppBar with gradient
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange,
                Colors.orange.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Iconsax.arrow_left,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Detail Pesanan',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        statusIcon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Status Progress Section
                Container(
                  margin: const EdgeInsets.all(TSizes.defaultSpace),
                  // child: _buildStatusProgressCard(context, statusColor, progressValue),
                ),

                // Main Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                  child: Column(
                    children: [
                      // Customer Information
                      _buildAnimatedCard(
                        context: context,
                        title: 'Informasi Pelanggan',
                        icon: Iconsax.profile_circle,
                        color: Colors.blue,
                        delay: 0,
                        child: _buildCustomerInfo(context),
                      ),
                      
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Order Information
                      _buildAnimatedCard(
                        context: context,
                        title: 'Informasi Pesanan',
                        icon: Iconsax.receipt_text,
                        color: Colors.purple,
                        delay: 100,
                        child: _buildOrderInfo(context),
                      ),
                      
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Products List
                      _buildAnimatedCard(
                        context: context,
                        title: 'Produk Dipesan',
                        icon: Iconsax.shopping_cart,
                        color: Colors.green,
                        delay: 200,
                        child: _buildProductsList(context),
                      ),
                      
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Total Price
                      _buildTotalPriceCard(context, totalPrice),
                      
                      const SizedBox(height: TSizes.spaceBtwSections * 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Floating Action Buttons
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: FloatingActionButton(
              heroTag: "share",
              onPressed: () {
                HapticFeedback.mediumImpact();
                _showShareBottomSheet(context);
              },
              backgroundColor: Colors.orange,
              child: const Icon(Iconsax.share, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          ScaleTransition(
            scale: _scaleAnimation,
            child: FloatingActionButton.extended(
              heroTag: "reorder",
              onPressed: () {
                HapticFeedback.mediumImpact();
                _showReorderDialog(context);
              },
              backgroundColor: Colors.orange,
              icon: const Icon(Iconsax.refresh_circle, color: Colors.white),
              label: const Text(
                'Pesan Lagi',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildStatusProgressCard(BuildContext context, Color statusColor, double progressValue) {
  //   return ScaleTransition(
  //     scale: _scaleAnimation,
  //     child: Container(
  //       padding: const EdgeInsets.all(24),
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [
  //             statusColor.withOpacity(0.1),
  //             statusColor.withOpacity(0.05),
  //           ],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //         border: Border.all(color: statusColor.withOpacity(0.2)),
  //         boxShadow: [
  //           BoxShadow(
  //             color: statusColor.withOpacity(0.1),
  //             blurRadius: 10,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                   color: statusColor,
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Icon(
  //                   _getStatusIcon(widget.order.status),
  //                   color: Colors.white,
  //                   size: 24,
  //                 ),
  //               ),
  //               const SizedBox(width: 16),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'Status Pesanan',
  //                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                         color: Colors.grey[600],
  //                       ),
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                       decoration: BoxDecoration(
  //                         color: statusColor,
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: Text(
  //                         widget.order.status.toUpperCase(),
  //                         style: const TextStyle(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 20),
  //           AnimatedBuilder(
  //             animation: _progressAnimation,
  //             builder: (context, child) {
  //               return Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         'Progress',
  //                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                       Text(
  //                         '${(progressValue * _progressAnimation.value * 100).toInt()}%',
  //                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                           fontWeight: FontWeight.bold,
  //                           color: statusColor,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 8),
  //                   LinearProgressIndicator(
  //                     value: progressValue * _progressAnimation.value,
  //                     backgroundColor: Colors.grey[300],
  //                     valueColor: AlwaysStoppedAnimation<Color>(statusColor),
  //                     minHeight: 8,
  //                   ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAnimatedCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required int delay,
    required Widget child,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double animation, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animation)),
          child: Opacity(
            opacity: animation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: RoundedContainer(
                showBorder: false,
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.white,
                radius: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    child,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.user,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            widget.order.customerName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow(
          context,
          icon: Iconsax.receipt_item,
          label: 'ID Pesanan',
          value: '#${widget.order.id}',
          color: Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          icon: Iconsax.status,
          label: 'Status',
          value: widget.order.status,
          color: _getStatusColor(widget.order.status),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          icon: Iconsax.calendar_add,
          label: 'Tanggal Dibuat',
          value: DateFormat('dd MMM yyyy, HH:mm').format(widget.order.createdAt ?? DateTime.now()),
          color: Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          icon: Iconsax.calendar_edit,
          label: 'Terakhir Diperbarui',
          value: DateFormat('dd MMM yyyy, HH:mm').format(widget.order.updatedAt ?? DateTime.now()),
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.order.products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        final product = widget.order.products[index];
        final subtotal = product.price * product.quantity;
        
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double animation, child) {
            return Transform.scale(
              scale: animation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Iconsax.coffee,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            product.productName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildProductDetail(
                            context,
                            icon: Iconsax.money_3,
                            label: 'Harga',
                            value: 'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(product.price)}',
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildProductDetail(
                          context,
                          icon: Iconsax.math,
                          label: 'Jumlah',
                          value: '${product.quantity}x',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.calculator,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Subtotal: Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(subtotal)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductDetail(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalPriceCard(BuildContext context, int totalPrice) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double animation, child) {
        return Transform.scale(
          scale: animation,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.orange.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.wallet_3,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 1000),
                        tween: IntTween(begin: 0, end: totalPrice),
                        builder: (context, int value, child) {
                          return Text(
                            'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(value)}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showShareBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Iconsax.share, color: Colors.orange),
                const SizedBox(width: 12),
                Text(
                  'Bagikan Pesanan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Fitur berbagi akan segera tersedia!'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Tutup', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showReorderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Iconsax.refresh_circle, color: Colors.orange),
            const SizedBox(width: 12),
            const Text('Pesan Lagi?'),
          ],
        ),
        content: const Text('Apakah Anda ingin memesan produk yang sama lagi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add reorder logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur pesan ulang akan segera tersedia!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Ya, Pesan Lagi', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
      case 'delivery':
        return Colors.purple;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Iconsax.clock;
      case 'processing':
        return Iconsax.coffee;
      case 'shipped':
      case 'delivery':
        return Iconsax.truck;
      case 'delivered':
      case 'completed':
        return Iconsax.tick_circle;
      case 'cancelled':
        return Iconsax.close_circle;
      default:
        return Iconsax.receipt_2;
    }
  }

  double _getProgressValue(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 0.25;
      case 'processing':
        return 0.5;
      case 'shipped':
      case 'delivery':
        return 0.75;
      case 'delivered':
      case 'completed':
        return 1.0;
      case 'cancelled':
        return 0.0;
      default:
        return 0.25;
    }
  }
}