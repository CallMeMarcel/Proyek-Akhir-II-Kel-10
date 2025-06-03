// import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/constants/text_strings.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TermsCondition extends StatelessWidget {
  const TermsCondition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    
    return Row(
      children: [
        SizedBox(
          width: 12, 
          height: 24, 
          child: Checkbox(
            value: true, 
            onChanged: (value) {},
            activeColor: dark ? Colors.orange[400] : Colors.orange[600],
            checkColor: Colors.white,
            side: BorderSide(
              color: dark ? Colors.orange[300]! : Colors.orange[500]!,
              width: 2.0,
            ),
          )
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${TTexts.iAgreeTo} ', 
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: dark ? Colors.grey[300] : Colors.grey[700],
                  )
                ),
                TextSpan(
                  text: '${TTexts.privacyPolicy} ', 
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? Colors.orange[300] : Colors.orange[600],
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? Colors.orange[300] : Colors.orange[600],
                  )
                ),
                TextSpan(
                  text: '${TTexts.and} ', 
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: dark ? Colors.grey[300] : Colors.grey[700],
                  )
                ),
                TextSpan(
                  text: '${TTexts.termsOfUse} ', 
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? Colors.orange[300] : Colors.orange[600],
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? Colors.orange[300] : Colors.orange[600],
                  )
                ),
              ]
            )
          ),
        )
      ],
    );
  }
}