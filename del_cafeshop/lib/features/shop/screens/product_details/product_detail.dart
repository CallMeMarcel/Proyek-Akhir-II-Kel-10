import 'package:del_cafeshop/common/widgets/texts/section_heading.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/features/shop/controlles/cart_controller.dart';
import 'package:del_cafeshop/features/shop/screens/checkout/checkout.dart';
import 'package:del_cafeshop/features/shop/screens/product_details/widgets/bottom_add_cart.dart';
import 'package:del_cafeshop/features/shop/screens/product_details/widgets/product_attribute.dart';
import 'package:del_cafeshop/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:del_cafeshop/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:del_cafeshop/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:del_cafeshop/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final cartController = Get.put(CartController());

    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          /// Enhanced App Bar
          _buildSliverAppBar(context, dark),
          
          /// Product Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    /// Product Image Slider
                    _buildImageSection(),
                    
                    /// Product Details Container
                    _buildProductDetailsContainer(context, dark, cartController),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: _buildEnhancedBottomBar(context, dark, cartController),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool dark) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: dark ? Colors.black : Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: dark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Iconsax.arrow_left_2,
            color: dark ? Colors.white : Colors.black,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: dark ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              // Share functionality
            },
            icon: Icon(
              Iconsax.share,
              color: dark ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 55, bottom: 16),
        title: Text(
          'Detail Produk',
          style: TextStyle(
            color: dark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: ProductImageSlider(product: widget.product),
      ),
    );
  }

  Widget _buildProductDetailsContainer(BuildContext context, bool dark, CartController cartController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: dark ? Colors.grey.shade900 : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Enhanced Header with Rating & Share
            _buildProductHeader(context, dark),
            
            const SizedBox(height: 24),
            
            /// Enhanced Product Meta Data
            _buildEnhancedMetaData(context, dark),
            
            const SizedBox(height: 24),
            
            /// Product Attributes
            // ProductAttribute(product: widget.product),
            
            const SizedBox(height: 32),
            
            /// Enhanced Action Buttons
            _buildActionButtons(context, dark, cartController),
            
            const SizedBox(height: 32),
            
            /// Enhanced Description Section
            _buildDescriptionSection(context, dark),
            
            const SizedBox(height: 32),
            
            /// Enhanced Features Section
            _buildFeaturesSection(context, dark),
            
            const SizedBox(height: 50), // Space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader(BuildContext context, bool dark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.product.status ?? '').withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(widget.product.status ?? '').withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(widget.product.status ?? ''),
                      size: 14,
                      color: _getStatusColor(widget.product.status ?? ''),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.product.status?.toUpperCase() ?? 'TERSEDIA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(widget.product.status ?? ''),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.product.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white : Colors.black,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const RatingAndShare(),
      ],
    );
  }

  Widget _buildEnhancedMetaData(BuildContext context, bool dark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark 
            ? [Colors.grey.shade800, Colors.grey.shade900]
            : [Colors.blue.shade50, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dark ? Colors.grey.shade700 : Colors.blue.shade100,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  dark,
                  Iconsax.money_recive,
                  'Harga',
                  _formatPrice(widget.product.price),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  context,
                  dark,
                  Iconsax.category,
                  'Kategori',
                  widget.product.category?.name ?? 'No Category',
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProductMetaData(product: widget.product),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, bool dark, IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: dark ? Colors.white : Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool dark, CartController cartController) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            dark,
            'Add Cart',
            Iconsax.shopping_cart,
            Colors.blue,
            () {
              if (widget.product.status?.toLowerCase() == 'unavailable') {
                _showSnackbar('Produk Tidak Tersedia', 'Maaf, produk ini sedang tidak tersedia.', Colors.orange, Iconsax.warning_2);
                return;
              }
              cartController.addToCart(widget.product);
              _showSnackbar('Berhasil!', 'Produk berhasil ditambahkan ke keranjang', Colors.green, Iconsax.tick_circle);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            context,
            dark,
            'Buy Now!',
            Iconsax.flash_1,
            Colors.orange,
            () {
              if (widget.product.status?.toLowerCase() == 'unavailable') {
                _showSnackbar('Produk Tidak Tersedia', 'Maaf, produk ini sedang tidak tersedia.', Colors.orange, Iconsax.warning_2);
                return;
              }
              cartController.addToCart(widget.product);
              cartController.selectedProducts.add(widget.product);
              Get.to(() => const CheckoutScreen());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, bool dark, String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, bool dark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark ? Colors.grey.shade800 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.document_text_1,
                  size: 20,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Deskripsi Produk',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ReadMoreText(
            widget.product.description ?? 'Tidak ada deskripsi tersedia untuk produk ini. Silakan hubungi customer service untuk informasi lebih lanjut.',
            trimLines: 3,
            trimMode: TrimMode.Line,
            trimExpandedText: ' Sembunyikan',
            trimCollapsedText: ' Selengkapnya',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: dark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
            moreStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
            lessStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
            delimiter: '...',
          ),
        ],
      ),
    );
  }

Widget _buildFeaturesSection(BuildContext context, bool dark) {
  final features = [
    {'icon': Iconsax.shield_tick, 'title': 'Produk Sehat', 'desc': 'Produk berkualitas tinggi'},
    {'icon': Iconsax.timer_1, 'title': 'Proses Cepat', 'desc': 'Dijamin Ga Pake Lama'},
    {'icon': Iconsax.medal_star, 'title': 'Rating Tinggi', 'desc': 'Dipercaya ribuan customer'},
    // {'icon': Iconsax.refresh_circle, 'title': 'Garansi Return', 'desc': 'Bisa dikembalikan 7 hari'},
  ];

  return SingleChildScrollView( // 👈 Bungkus keseluruhan agar bisa discroll
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
                Iconsax.star,
                size: 20,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Keunggulan Produk',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: dark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Supaya tidak scroll di dalam scroll
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: dark ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: dark ? Colors.grey.shade700 : Colors.grey.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    feature['icon'] as IconData,
                    size: 24,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feature['title'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: dark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature['desc'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

  Widget _buildEnhancedBottomBar(BuildContext context, bool dark, CartController cartController) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark ? Colors.grey.shade900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomAddCart(product: widget.product),
      ),
    );
  }

  // Helper Methods
  String _formatPrice(double price) {
    return 'Rp${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'baru':
        return Colors.green;
      case 'sale':
      case 'diskon':
        return Colors.red;
      case 'hot':
      case 'populer':
        return Colors.orange;
      case 'unavailable':
      case 'habis':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'baru':
        return Iconsax.star;
      case 'sale':
      case 'diskon':
        return Iconsax.discount_shape;
      case 'hot':
      case 'populer':
        return Iconsax.empty_wallet;
      case 'unavailable':
      case 'habis':
        return Iconsax.close_circle;
      default:
        return Iconsax.tag;
    }
  }

  void _showSnackbar(String title, String message, Color color, IconData icon) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}