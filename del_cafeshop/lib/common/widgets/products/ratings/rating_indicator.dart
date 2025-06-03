import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class PRatingBarInput extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingUpdate;

  const PRatingBarInput({
    super.key,
    required this.rating,
    required this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 24,
      unratedColor: TColors.grey,
      itemBuilder: (context, _) => const Icon(Iconsax.star, color: TColors.primary),
      onRatingUpdate: onRatingUpdate,
    );
  }
}
