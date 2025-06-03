import 'package:del_cafeshop/common/widgets/appbar/appbar.dart';
import 'package:del_cafeshop/common/widgets/custom_shapes/curved_edges/curved_widget.dart';
import 'package:del_cafeshop/common/widgets/icons/circular_icon.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductImageSlider extends StatelessWidget {
  final Product product;

  const ProductImageSlider({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final imageUrl = product.image.isNotEmpty ? product.image : null;

    return CurvedEdgeWidget(
      child: Container(
        color: dark ? TColors.dark : TColors.light,
        child: Stack(
          children: [
            /// Gambar utama produk
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(TSizes.productImageRadius * 2),
                child: Center(
                  child: imageUrl != null
                      ? Image.network(imageUrl)
                      : const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),

            /// Tombol kembali dan favorit
            const TAppbar(
              showBackArrow: false,
              actions: [
                // CircularIcon(
                //   icon: Iconsax.heart5,
                //   color: Colors.red,
                //   backgroundColor: Colors.transparent,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
