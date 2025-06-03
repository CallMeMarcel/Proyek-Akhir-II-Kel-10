// import 'package:del_cafeshop/common/widgets/products/ratings/rating_indicator.dart';
// import 'package:del_cafeshop/data/models/review.dart';
// import 'package:del_cafeshop/utils/constants/colors.dart';
// import 'package:del_cafeshop/utils/constants/image_strings.dart';
// import 'package:del_cafeshop/utils/constants/sizes.dart';
// import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:readmore/readmore.dart';

// class UserReviewCard extends StatelessWidget {
//   final Review review;

//   const UserReviewCard({super.key, required this.review});

//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 const CircleAvatar(backgroundImage: AssetImage(TImages.user)),
//                 const SizedBox(width: TSizes.spaceBtwItems),
//                 Text(review.username, style: Theme.of(context).textTheme.titleLarge),
//               ],
//             ),
//             IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
//           ],
//         ),
//         const SizedBox(height: TSizes.spaceBtwItems),
//         Row(
//           children: [
//             PRatingBarIndicator(rating: review.rating),
//             const SizedBox(width: TSizes.spaceBtwItems),
//             Text(review.createdAt, style: Theme.of(context).textTheme.bodyMedium),
//           ],
//         ),
//         const SizedBox(height: TSizes.spaceBtwItems),
//         ReadMoreText(
//           review.comment,
//           trimLines: 1,
//           trimMode: TrimMode.Line,
//           trimExpandedText: 'show less',
//           trimCollapsedText: 'show more',
//           moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
//           lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
//         ),
//         const Divider(),
//       ],
//     );
//   }
// }
