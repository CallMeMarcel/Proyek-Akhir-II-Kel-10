import 'package:del_cafeshop/common/widgets/icons/circular_icon.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/features/shop/controlles/cart_controller.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class BottomAddCart extends StatefulWidget {
  final Product product;

  const BottomAddCart({super.key, required this.product});

  @override
  State<BottomAddCart> createState() => _BottomAddCartState();
}

class _BottomAddCartState extends State<BottomAddCart> {
  int quantity = 1;
  final CartController cartController = Get.put(CartController());

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _addToCart() {
    // ✅ Cek status produk
    if (widget.product.status?.toLowerCase() == 'unavailable') {
      Get.snackbar(
        'Produk Tidak Tersedia',
        'Maaf, produk ini sedang tidak tersedia.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ Set jumlah quantity ke dalam product
    widget.product.quantity.value = quantity;

    cartController.addToCart(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $quantity ${widget.product.title} to cart'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.defaultSpace / 2,
      ),
      decoration: BoxDecoration(
        color: dark ? TColors.darkGrey : TColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TSizes.cardRadiusLg),
          topRight: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Quantity Selector
          Row(
            children: [
              CircularIcon(
                icon: Iconsax.minus,
                backgroundColor: TColors.darkGrey,
                width: 40,
                height: 40,
                color: TColors.white,
                onPressed: _decrementQuantity,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text('$quantity', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: TSizes.spaceBtwItems),
              CircularIcon(
                icon: Iconsax.add,
                backgroundColor: TColors.black,
                width: 40,
                height: 40,
                color: TColors.white,
                onPressed: _incrementQuantity,
              ),
            ],
          ),

          // Add to Cart Button
          ElevatedButton(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(TSizes.md),
              backgroundColor: TColors.black,
              side: const BorderSide(color: TColors.black),
            ),
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
