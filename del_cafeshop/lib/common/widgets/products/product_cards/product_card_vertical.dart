import 'package:del_cafeshop/features/shop/controlles/cart_controller.dart';
import 'package:del_cafeshop/features/shop/controlles/whistlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:del_cafeshop/common/styles/shadows.dart';
import 'package:del_cafeshop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:del_cafeshop/common/widgets/icons/circular_icon.dart';
import 'package:del_cafeshop/common/widgets/texts/brand_title_verified_icon.dart';
import 'package:del_cafeshop/common/widgets/texts/product_price_text.dart';
import 'package:del_cafeshop/common/widgets/texts/product_title_text.dart';
import 'package:del_cafeshop/features/shop/screens/product_details/product_detail.dart';
import 'package:del_cafeshop/utils/constants/api_constants.dart';

class ProductCardVertical extends StatelessWidget {
  final Product product;
  final double width;
  final bool showAddToCart;
  final VoidCallback? onAddToCart;
  final bool isWishlisted;
  final VoidCallback? onWishlistPressed;

  const ProductCardVertical({
    super.key,
    required this.product,
    this.width = 180,
    this.showAddToCart = true,
    this.onAddToCart,
    this.isWishlisted = false,
    this.onWishlistPressed,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();
    final dark = THelperFunctions.isDarkMode(context);
    final priceText = _formatPrice(product.price);

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetail(product: product)),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(TSizes.sm),
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Thumbnail, Wishlist, Discount Tag ---
            RoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  /// -- Thumbnail Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(TSizes.productImageRadius),
                      child: Image.network(
                        _getImageUrl(product.image),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          TImages.failed,
                          fit: BoxFit.contain,
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),

                  /// -- Sale Tag
                  if (product.status.isNotEmpty)
                    Positioned(
                      child: RoundedContainer(
                        radius: TSizes.sm,
                        backgroundColor: const Color.fromARGB(255, 38, 111, 248),
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm,
                          vertical: TSizes.xs,
                        ),
                        child: Text(
                          product.status.toLowerCase(),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: TColors.white),
                        ),
                      ),
                    ),

                  /// -- Favourite Icon Button
                  Positioned(
                    top: -5,
                    right: -12,
                    child: GestureDetector(
                      onTap: () {
                        wishlistController.toggleWishlist(product);

                        // Update the wishlist status directly
                        // Remove Snackbar notifikasi
                        // Perbarui icon warna wishlist secara langsung
                      },
                      behavior: HitTestBehavior.translucent,
                      child:Obx(() => CircularIcon(
                      icon: wishlistController.isWishlisted(product)
                          ? Iconsax.heart5
                          : Iconsax.heart,
                      color: wishlistController.isWishlisted(product)
                          ? Colors.red
                          : null,
                      backgroundColor: dark
                          ? TColors.dark.withOpacity(0.9)
                          : TColors.light,
                    )),

                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems / 2),

            /// --- Product Title and Category ---
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTitleText(
                    title: product.title,
                    smallSize: true,
                    maxLines: 2,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 4),
                  BrandTitleWithVerifiedIcon(
                    title: product.category?.name ?? 'No Category',
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems / 2),

            /// -- Price & Add to Cart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ProductPrice(
                      price: priceText,
                      isLarge: false,
                    ),
                  ),
                  if (showAddToCart) _buildAddToCartButton(),
                ],
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

  String _getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) return imagePath;
    return '${APIConstants.baseUrl}/storage/$imagePath';
  }

  Widget _buildAddToCartButton() {
  final cartController = Get.find<CartController>();

  return InkWell(
    onTap: () {
      if (product.status.toLowerCase() == 'unavailable') {
        Get.snackbar('Gagal', 'Tidak dapat menambahkan, dikarenakan stok habis',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        return;
      }

      cartController.addToCart(product);
      Get.snackbar('Berhasil', 'Produk ditambahkan ke keranjang');
    },
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(TSizes.cardRadiusMd),
      bottomRight: Radius.circular(TSizes.productImageRadius),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: TColors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TSizes.cardRadiusMd),
          bottomRight: Radius.circular(TSizes.productImageRadius),
        ),
      ),
      child: const SizedBox(
        width: TSizes.iconLg * 1.2,
        height: TSizes.iconLg * 1.2,
        child: Icon(Iconsax.add, color: TColors.white),
      ),
    ),
  );
}

}
