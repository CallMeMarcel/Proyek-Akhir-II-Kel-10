import 'package:del_cafeshop/common/widgets/appbar/appbar.dart';
import 'package:del_cafeshop/common/widgets/icons/circular_icon.dart';
import 'package:del_cafeshop/common/widgets/layouts/grid_layout.dart';
import 'package:del_cafeshop/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:del_cafeshop/features/shop/controlles/whistlist_controller.dart';
import 'package:del_cafeshop/features/shop/screens/home/home.dart';
import 'package:del_cafeshop/features/shop/screens/store/store.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation controllers
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fabAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: TAppbar(
        title: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Row(
                children: [
                  Icon(
                    Iconsax.heart5,
                    color: Colors.orange.shade400,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'My Wishlist',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          AnimatedBuilder(
            animation: _fabScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _fabScaleAnimation.value,
                child: CircularIcon(
                  icon: Iconsax.shop,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    // Add subtle haptic feedback
                    HapticFeedback.lightImpact();
                    Get.to(
                      const HomeScreen(),
                      transition: Transition.rightToLeftWithFade,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: GetBuilder<WishlistController>(
        init: WishlistController(), // Initialize controller here
        builder: (wishlistController) {
          final allProducts = wishlistController.wishlistItems;
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: _buildBody(allProducts, wishlistController),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabScaleAnimation.value,
            child: FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Get.to(
                  const StoreScreen(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 500),
                );
              },
              backgroundColor: Colors.orange.shade400,
              elevation: 8,
              icon: const Icon(Iconsax.add_circle, color: Colors.white),
              label: const Text(
                'Add More',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(List allProducts, WishlistController wishlistController) {
    if (allProducts.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Add refresh haptic feedback
        HapticFeedback.mediumImpact();
        // You can add refresh logic here if needed
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: Colors.orange.shade400,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with count
              _buildWishlistHeader(allProducts.length),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              // Products grid with staggered animation
              _buildProductsGrid(allProducts, wishlistController),
              
              // Bottom spacing for FAB
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistHeader(int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade400.withOpacity(0.1),
            Colors.orange.shade400.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.shade400.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Iconsax.heart5,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Favorites',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count ${count == 1 ? 'item' : 'items'} saved',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.shade400.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: Colors.orange.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(List allProducts, WishlistController wishlistController) {
    return GridLayout(
      itemCount: allProducts.length,
      itemBuilder: (_, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: ProductCardVertical(
                  product: allProducts[index],
                  isWishlisted: true,
                  onWishlistPressed: () {
                    // Add haptic feedback for wishlist toggle
                    HapticFeedback.lightImpact();
                    
                    // Show confirmation with animation
                    _showRemoveConfirmation(
                      context,
                      allProducts[index],
                      wishlistController,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated empty illustration
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.bounceOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.heart_slash,
                      size: 60,
                      color: Colors.orange.shade400.withOpacity(0.6),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            
            Text(
              'Your Wishlist is Empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade400,
              ),
            ),
            const SizedBox(height: 12),
            
            Text(
              'Start adding products you love to see them here',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            
            // Animated button
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Get.to(
                        const HomeScreen(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                    icon: const Icon(Iconsax.shop),
                    label: const Text('Start Shopping'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveConfirmation(
    BuildContext context,
    dynamic product,
    WishlistController wishlistController,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Iconsax.heart_remove,
                color: Colors.orange.shade400,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text('Remove from Wishlist?'),
            ],
          ),
          content: const Text(
            'Are you sure you want to remove this item from your wishlist?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                wishlistController.toggleWishlist(product);
                
                // Show success message
                Get.snackbar(
                  'Removed',
                  'Item removed from wishlist',
                  icon: const Icon(Iconsax.tick_circle, color: Colors.white),
                  backgroundColor: Colors.orange.shade400,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}