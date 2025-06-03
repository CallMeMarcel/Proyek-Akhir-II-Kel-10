import 'package:del_cafeshop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:del_cafeshop/common/widgets/texts/brand_title_verified_icon.dart';
import 'package:del_cafeshop/common/widgets/texts/product_price_text.dart';
import 'package:del_cafeshop/common/widgets/texts/product_title_text.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/enums.dart';
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ProductMetaData extends StatelessWidget {
  final Product product;
  
  const ProductMetaData({super.key, required this.product});

  String _formatPrice(double price) {
    return 'Rp${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Price
        ProductPrice(
          price: _formatPrice(product.price),
          isLarge: true,
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        // Product Title
        ProductTitleText(
          title: product.title,
          maxLines: 2,
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        // Stock Status
        Row(
          children: [
            const ProductTitleText(title: 'Status:'),
            const SizedBox(width: TSizes.spaceBtwItems / 2),
            Text(
              product.status,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: product.status.toLowerCase() == 'available' 
                    ? TColors.success 
                    : TColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        // Category Section
        if (product.category != null) 
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  _getCategoryImage(product.category!.name),
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.category,
                    size: 32,
                    color: dark ? TColors.white : TColors.dark,
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              BrandTitleWithVerifiedIcon(
                title: product.category!.name,
                brandTextSizes: TextSizes.medium,
              ),
            ],
          ),
      ],
    );
  }

  String _getCategoryImage(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'drink':
        return TImages.drink;
      case 'food':
        return TImages.food;
      default:
        return TImages.food; // default image
    }
  }
}