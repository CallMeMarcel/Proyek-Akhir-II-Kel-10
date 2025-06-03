import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class RoundedImages extends StatelessWidget {
  const RoundedImages({
    super.key, 
    this.width, 
    this.height, 
    required this.imageUrl, 
    this.applyImageRadius = true, 
    this.border, 
    this.backgroundColor = TColors.white, 
    this.fit = BoxFit.contain, 
    this.padding, 
    this.isNetworkImage = false , 
    this.onPressed, 
    this.borderRadius = TSizes.md, 
    this.errorWidget, 
    this.placeholder,

  });
  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border; 
  final Color backgroundColor;
  final Widget? errorWidget;
  final Widget? placeholder;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border, color: backgroundColor, borderRadius: BorderRadius.circular(borderRadius)),
        child: 
        ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(TSizes.md) : BorderRadius.zero,
        child: isNetworkImage
      ? Image.network(
          imageUrl,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return placeholder ?? const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? const Icon(Icons.error);
          },
        )
      : Image.asset(
          imageUrl,
          fit: fit,
        ),
        ),
      ),
    );
  }
}

