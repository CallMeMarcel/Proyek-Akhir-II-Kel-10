  import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

Widget buildPaymentOption(
    BuildContext context, {
    required int index,
    required bool selected,
    required IconData icon,
    required String title,
    String? subtitle,
    String? iconImage,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TSizes.sm),
        margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
        decoration: BoxDecoration(
          color: selected ? TColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          border: selected 
              ? Border.all(color: TColors.primary) 
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(TSizes.xs),
              decoration: BoxDecoration(
                color: THelperFunctions.isDarkMode(context) 
                    ? TColors.darkerGrey 
                    : TColors.light,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
              ),
              child: iconImage != null
                  ? Image.asset(iconImage, height: 24)
                  : Icon(icon, color: TColors.primary),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  if (subtitle != null)
                    Text(subtitle, 
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Radio<int>(
              value: index,
              groupValue: selected ? index : null,
              onChanged: (_) => onTap(),
              activeColor: TColors.primary,
            ),
          ],
        ),
      ),
    );
  }
