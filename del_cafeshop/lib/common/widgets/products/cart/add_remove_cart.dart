import 'package:del_cafeshop/common/widgets/icons/circular_icon.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:del_cafeshop/features/shop/controlles/cart_controller.dart';

class ProductQuantityWithAddRemove extends StatelessWidget {
  final Product product;

  const ProductQuantityWithAddRemove({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final cartController = Get.find<CartController>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Minus Button
        CircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: isDark ? TColors.black : TColors.white,
          backgroundColor: isDark ? TColors.white : TColors.black,
          onPressed: () => cartController.decreaseQuantity(product),
        ),

        const SizedBox(width: TSizes.spaceBtwItems),

        /// Quantity Text (Reaktif)
        Obx(() {
          // Dapatkan kembali produk yang sesuai dari cart
          final cartProduct = cartController.cartItems.firstWhereOrNull(
            (item) => item == product,
          );

          final quantity = cartProduct?.quantity ?? product.quantity ?? 1;

          return Text(
            '$quantity',
            style: Theme.of(context).textTheme.titleSmall,
          );
        }),

        const SizedBox(width: TSizes.spaceBtwItems),

        /// Add Button
        CircularIcon(
          icon: Iconsax.add,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: TColors.white,
          backgroundColor: TColors.primary,
          onPressed: () => cartController.increaseQuantity(product),
        ),
      ],
    );
  }
}
