import 'package:del_cafeshop/common/styles/spacing_styles.dart';
import 'package:del_cafeshop/common/widgets/login_signup/form_divider.dart';
import 'package:del_cafeshop/features/authentication/screens/login/widgets/login_form.dart';
import 'package:del_cafeshop/common/widgets/login_signup/social_button.dart';
import 'package:del_cafeshop/features/authentication/screens/login/widgets/login_header.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // Login Header
              const LoginHeader(),

              // Login Form
              const SizedBox(height: TSizes.spaceBtwItems),
              const LoginForm(),

              // Divider
              // FormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Social Buttons
              // const SocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}