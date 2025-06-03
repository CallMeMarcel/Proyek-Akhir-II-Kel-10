import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BillingAmountSection extends StatelessWidget {
  const BillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal' , style: Theme.of(context).textTheme.bodyMedium,),
            Text('Rp.8000' , style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2,),

        // Shipping fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Shipping Fee', style: Theme.of(context).textTheme.bodyMedium,),
          Text('Rp 1500', style: Theme.of(context).textTheme.labelLarge,),
        ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2,),

        // Tax Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium,),
          Text('Rp 500', style: Theme.of(context).textTheme.labelLarge,),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems /2,),


        // Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.bodyMedium),
            Text('Rp.30000' , style: Theme.of(context).textTheme.titleMedium,),
          ],
        )
      ],
    );
  }
}