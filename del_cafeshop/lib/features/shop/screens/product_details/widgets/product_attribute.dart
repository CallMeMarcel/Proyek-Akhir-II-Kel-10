import 'package:del_cafeshop/common/widgets/chips/choice_chip.dart';
import 'package:del_cafeshop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:del_cafeshop/common/widgets/texts/product_price_text.dart';
import 'package:del_cafeshop/common/widgets/texts/product_title_text.dart';
import 'package:del_cafeshop/common/widgets/texts/section_heading.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
// ... other imports ...

class ProductAttribute extends StatefulWidget {
  final Product product;
  
  const ProductAttribute({super.key, required this.product});

  @override
  State<ProductAttribute> createState() => _ProductAttributeState();
}

class _ProductAttributeState extends State<ProductAttribute> {
  String _formatPrice(double price) {
    return 'Rp${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  void _handleToppingSelection(int index, bool selected) {
    setState(() {
      widget.product.toppings?[index].isSelected = selected;
    });
    // You could add price calculation logic here
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final product = widget.product;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Variation Section
        RoundedContainer(
          backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Price & Stock
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeading(
                      title: 'Variation',
                      showActionButton: false,
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price Row
                          Row(
                            children: [
                              const ProductTitleText(
                                title: 'Price : ',
                                smallSize: true,
                              ),
                              ProductPrice(
                                price: _formatPrice(product.price ?? 0),
                                isLarge: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Stock Row
                          Row(
                            children: [
                              const ProductTitleText(
                                title: 'Stock : ',
                                smallSize: true,
                              ),
                              Text(
                                product.status ?? 'N/A',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: (product.status?.toLowerCase() == 'available') 
                                      ? TColors.success 
                                      : TColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (product.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ProductTitleText(
                    title: product.description!,
                    smallSize: true,
                    maxLines: 4,
                  ),
                ],
              ],
            ),
          ),
        ),

        // Toppings Section
        if (product.toppings?.isNotEmpty ?? false) ...[
          const SizedBox(height: TSizes.spaceBtwItems),
          const SectionHeading(
            title: 'Toppings (optional)',
            showActionButton: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Wrap(
            spacing: 8,
            children: List.generate(product.toppings!.length, (index) {
              final topping = product.toppings![index];
              return CustomChoiceChip(
                text: topping.name,
                selected: topping.isSelected ?? false,
                onSelected: (selected) => _handleToppingSelection(index, selected),
              );
            }),
          ),
        ],
      ],
    );
  }
}