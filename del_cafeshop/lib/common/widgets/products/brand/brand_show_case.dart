import 'package:del_cafeshop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:del_cafeshop/common/widgets/products/brand/brand_card.dart';
import 'package:del_cafeshop/data/models/category.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class BrandShowCase extends StatelessWidget {
  const BrandShowCase({
    super.key,
    required this.images,
    required this.category,
  });

  final List<String> images;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      showBorder: true,
      borderColor: TColors.darkGrey,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(TSizes.md),
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Column(
        children: [
          BrandCard(
            showBorder: false,
            category: category,
          ),
          Row(
            children: images.take(3).map((image) => brandTopProductImagesWidget(image, context)).toList(),
          ),
        ],
      ),
    );
  }

  Widget brandTopProductImagesWidget(String image, context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: TSizes.sm),
        child: RoundedContainer(
          height: 100,
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.light,
          padding: const EdgeInsets.all(TSizes.md),
          child: Image.network(
            image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }
}
