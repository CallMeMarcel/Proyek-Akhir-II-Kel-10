import 'package:del_cafeshop/common/widgets/custom_shapes/containers/primary_header_controller.dart';
import 'package:del_cafeshop/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:del_cafeshop/common/widgets/layouts/grid_layout.dart';
import 'package:del_cafeshop/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:del_cafeshop/common/widgets/texts/section_heading.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/data/services/product_service.dart';
import 'package:del_cafeshop/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:del_cafeshop/features/shop/screens/home/widgets/home_category.dart';
import 'package:del_cafeshop/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  List<Product> products = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  String errorMessage = '';

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _staggerController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchProducts();
    searchController.addListener(_onSearchChanged);
    _startAnimations();
  }

  void _initializeAnimations() {
    // Fade Animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Slide Animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Scale Animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.bounceOut,
    ));

    // Stagger Animation
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _staggerController.forward();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) => product.title.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _fetchProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final fetchedProducts = await ProductService.getProducts();
      setState(() {
        products = fetchedProducts;
        filteredProducts = fetchedProducts;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildAnimatedSearchSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Column(
            children: [
              // Enhanced Search Container with Icon
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SearchContainer(
                  text: 'Search your favorite coffee...',
                  controller: searchController,
                  showBorder: true,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              
            
            ],
          ),
        ),
      ),
    );
  }

 
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  

  Widget _buildAnimatedPromoSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.3, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
        )),
        
        child: Container(
          
          margin: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Column(
            
            children: [
              Row(
                children: [
                  Icon(
                    Iconsax.discount_shape,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: SectionHeading(
                      title: 'Special Offers',
                      showActionButton: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const PromoSlider(banners: [
                TImages.promo1,
                TImages.promo2,
                TImages.promo3,
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedProductSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Column(
        children: [
          // Section Header with Icon
          FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.trend_up,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: SectionHeading(
                    title: 'Popular Products',
                    showActionButton: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Product Content
          if (isLoading)
            _buildLoadingAnimation()
          else if (errorMessage.isNotEmpty)
            _buildErrorWidget()
          else if (filteredProducts.isEmpty)
            _buildEmptyState()
          else
            _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.2,
              ).animate(
                CurvedAnimation(
                  parent: _fadeController,
                  curve: Curves.elasticInOut,
                ),
              ),
              child: Icon(
                Iconsax.coffee,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Brewing your favorites...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              Iconsax.warning_2,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchProducts,
              icon: const Icon(Iconsax.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Iconsax.search_normal,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, child) {
        return GridLayout(
          itemCount: filteredProducts.length > 4 ? 4 : filteredProducts.length,
          itemBuilder: (_, index) {
            final delay = index * 0.1;
            final animationValue = Curves.easeOut.transform(
              (_staggerController.value - delay).clamp(0.0, 1.0),
            );

            return Transform.translate(
              offset: Offset(0, 50 * (1 - animationValue)),
              child: Opacity(
                opacity: animationValue,
                child: ProductCardVertical(
                  product: filteredProducts[index],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchProducts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header Section
              FadeTransition(
                opacity: _fadeAnimation,
                child: PrimaryHeaderController(
                  child: Column(
                    children: [
                      const HomeAppBar(),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Enhanced Search Section
                      _buildAnimatedSearchSection(),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Categories Section
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.3, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _slideController,
                          curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                        )),
                        child: Padding(
                          padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Icon(
                                  //   Iconsax.category,
                                  //   color: Colors.white,
                                  //   size: 24,
                                  // ),
                                  const SizedBox(width: 8),
                                  // const SectionHeading(
                                  //   title: 'Popular Categories',
                                  //   showActionButton: false,
                                  //   textColor: Colors.white,
                                  // ),
                                ],
                              ),
                              // const SizedBox(height: TSizes.spaceBtwItems),
                              // const HomeCategory(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ),
                ),
              ),

              // Body Content
              Padding(
                padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace),
                child: Column(
                  children: [
                    // Promo Section
                    _buildAnimatedPromoSection(),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Products Section
                    _buildAnimatedProductSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}