// import 'dart:convert';

// import 'package:del_cafeshop/features/shop/screens/product_reviews/widgets/product_form.dart';
// import 'package:del_cafeshop/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:del_cafeshop/data/models/review.dart';
// import 'package:del_cafeshop/common/widgets/appbar/appbar.dart';
// import 'package:del_cafeshop/features/shop/screens/product_reviews/widgets/user_review_card.dart';
// import 'package:del_cafeshop/utils/constants/sizes.dart';

// class ProductReviewsScreen extends StatefulWidget {
//   final String productId; // Add productId parameter

//   const ProductReviewsScreen({super.key, required this.productId});

//   @override
//   State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
// }

// class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
//   List<Review> reviews = [];
//   bool isLoading = false;
//   double averageRating = 0.0;

//   Future<void> fetchReviews() async {
//     setState(() => isLoading = true);
    
//     try {
//       final url = Uri.parse('http://172.27.80.107:8000/api/reviews?productId=${widget.productId}');
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final List<Review> loadedReviews = (data['reviews'] as List)
//             .map((json) => Review.fromJson(json))
//             .toList();
        
//         final double avg = data['averageRating'] ?? 0.0;

//         setState(() {
//           reviews = loadedReviews;
//           averageRating = avg;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load reviews: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchReviews();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const TAppbar(title: Text('Reviews & Rating')),
//       body: RefreshIndicator(
//         onRefresh: fetchReviews,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product information and rating summary
//               Text(
//                 'Ratings and reviews are verified and are from people who use the same type of device that you use.',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               const SizedBox(height: TSizes.spaceBtwItems),

//               // Overall rating
//               OverallProductRating(rating: averageRating),
//               const SizedBox(height: TSizes.spaceBtwItems),

//               // Review count
//               Text(
//                 '${reviews.length} reviews',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//               const SizedBox(height: TSizes.spaceBtwSections),

//               // Review form
//               ReviewForm(
//                 productId: widget.productId,
//                 onReviewSubmitted: fetchReviews,
//               ),

//               // Reviews list
//               isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : reviews.isEmpty
//                       ? const Center(child: Text('No reviews yet'))
//                       : ListView.separated(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: reviews.length,
//                           separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
//                           itemBuilder: (_, index) => UserReviewCard(review: reviews[index]),
//                         ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }