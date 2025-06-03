import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: TColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(onPressed: () {},
           icon: const Image(
            width :  TSizes.iconMd,
            height: TSizes.iconMd,
            image: AssetImage(TImages.google), 
            ),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Container(
          decoration: BoxDecoration(border: Border.all(color: TColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(onPressed: () {},
           icon: const Image(
            width :  TSizes.iconMd,
            height: TSizes.iconMd,
            image: AssetImage(TImages.facebook), 
            ),
          ),
        ),
      ],
    );
  }
}
