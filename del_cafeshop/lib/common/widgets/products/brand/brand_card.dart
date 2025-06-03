import 'package:del_cafeshop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:del_cafeshop/common/widgets/images/circular_image.dart';
import 'package:del_cafeshop/common/widgets/texts/brand_title_verified_icon.dart';
import 'package:del_cafeshop/data/models/category.dart';
import 'package:del_cafeshop/data/services/product_service.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/enums.dart';
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key,
    required this.showBorder,
    this.onTap,
    required this.category,
  });

  final bool showBorder;
  final void Function()? onTap;
  final Category category;

  Future<int> getProductCount() async {
    try {
      final products = await ProductService.getProducts();
      final productCount = products.where((product) => product.categoryId == category.id).length;
      return productCount;
    } catch (e) {
      print('Failed to get product count: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        padding: const EdgeInsets.all(TSizes.sm),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          children: [
            // Icon
            Flexible(
              child: CircularImages(
                isNetworkImage: false,
                image: TImages.category,
                backgroundColor: Colors.transparent,
                overlayColor: THelperFunctions.isDarkMode(context) ? TColors.white : TColors.black,
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems / 2),

            // Text
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandTitleWithVerifiedIcon(
                    title: category.name,
                    brandTextSizes: TextSizes.large,
                  ),
                  FutureBuilder<int>(
                    future: getProductCount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Loading...',
                          style: TextStyle(fontSize: 12),
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                          'Error loading products',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        );
                      } else {
                        final count = snapshot.data ?? 0;
                        return Text(
                          '$count products',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
