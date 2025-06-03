import 'package:del_cafeshop/utils/constants/enums.dart';
import 'package:flutter/material.dart';

class BrandTitleText extends StatelessWidget {
  const BrandTitleText({
    super.key, 
    this.color, 
    required this.title, 
    this.maxLines = 1, 
    this.textAlign = TextAlign.center, 
    this.brandTextSizes = TextSizes.small,
    });

  final Color? color;
  final String title;
  final int maxLines;
  final TextAlign? textAlign;
  final TextSizes brandTextSizes;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      // Check which brandSize is required and set that style
      style: brandTextSizes == TextSizes.small
       ? Theme.of(context).textTheme.labelMedium!.apply(color: color)
       : brandTextSizes == TextSizes.medium
        ? Theme.of(context).textTheme.bodyLarge!.apply(color: color)
        : brandTextSizes == TextSizes.large
          ? Theme.of(context).textTheme.titleLarge!.apply(color: color)
          : Theme.of(context).textTheme.bodyMedium!.apply(color: color), 
    );
  }
}