
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/constants/text_strings.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
 
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child : Column(
            children: [
               ///Image
            Image(image: const AssetImage(TImages.onBoardingImage2), width: THelperFunctions.screenWidth() * 0.6),
            const SizedBox(height: TSizes.spaceBtwSections),
            ///Title & SubTitle
            Text(TTexts.changeYourPasswordTitle, style:  Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: TSizes.spaceBtwSections),
            Text(TTexts.changeYourPasswordSubTitle, style:  Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
            const SizedBox(height: TSizes.spaceBtwSections),
            ///Buttons
            SizedBox(width: double.infinity, 
            child: ElevatedButton(onPressed: () {}, child: const Text(TTexts.done))),
            const SizedBox(height: TSizes.spaceBtwItems),
             SizedBox(width: double.infinity, 
            child: TextButton(onPressed: () {}, child: const Text(TTexts.resendEmail))),
            ],
          )
        ),
      ),
    );
  }
}