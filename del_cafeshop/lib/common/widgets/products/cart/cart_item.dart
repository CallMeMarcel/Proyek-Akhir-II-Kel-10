import 'package:del_cafeshop/common/widgets/images/rounded_image.dart';
import 'package:del_cafeshop/common/widgets/texts/brand_title_verified_icon.dart';
import 'package:del_cafeshop/common/widgets/texts/product_title_text.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final Product product;

  const CartItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Product Image
        RoundedImages(
          imageUrl: _getImageUrl(product.image),
          isNetworkImage: true, // ⬅️ Tambahkan ini!
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: isDark ? TColors.darkerGrey : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),

        /// Product Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrandTitleWithVerifiedIcon(title: product.category?.name ?? 'Tanpa Kategori'),
              ProductTitleText(
                title: product.title,
                maxLines: 1,
              ),
              const SizedBox(height: TSizes.xs),

              /// Attribute (contoh: toping bisa disesuaikan dari properti product)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'deskripsi: ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: product.description ?? '-', 
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) return imagePath;
    return 'http://192.168.135.183:8000/storage/$imagePath';
  }
}
