import 'package:del_cafeshop/data/models/order.dart';
import 'package:del_cafeshop/data/services/order_service.dart';
import 'package:del_cafeshop/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:del_cafeshop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:del_cafeshop/features/shop/screens/order/order_detail.dart';

class OrderListItems extends StatelessWidget {
  const OrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final userProvider = Provider.of<UserProvider>(context);
    final int? userId = userProvider.userId;
    final String? token = userProvider.token;
    final String? userName = userProvider.name;

    print('OrderListItems build: userId = $userId, token = $token, userName = $userName');

    if (userId == null) {
      print('OrderListItems: userId is null, showing login message');
      return const Center(child: Text('Silakan login untuk melihat pesanan'));
    }

    return FutureBuilder<List<Order>>(
      future: OrderService().fetchOrders(userId, token: token, userName: userName),
      builder: (context, snapshot) {
        print('FutureBuilder state: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, hasError: ${snapshot.hasError}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('FutureBuilder error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('OrderListItems: No orders found');
          return const Center(child: Text('Tidak ada pesanan ditemukan'));
        }

        final orders = snapshot.data!;
        print('OrderListItems: Found ${orders.length} orders');

        return ListView.separated(
          shrinkWrap: true,
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final order = orders[index];
            return RoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(TSizes.md),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Iconsax.ship),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.status,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(color: TColors.primary, fontWeightDelta: 1),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(order.createdAt ?? DateTime.now()),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(() => OrderDetailScreen(order: order));
                        },
                        icon: const Icon(Iconsax.arrow_right_34, size: TSizes.iconSm),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    children: [
                      const Icon(Iconsax.tag),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order', style: Theme.of(context).textTheme.labelMedium),
                            Text('[#${order.id}]', style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      ),
                      const Icon(Iconsax.calendar),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Shipping Date', style: Theme.of(context).textTheme.labelMedium),
                            Text(
                              DateFormat('dd MMM yyyy').format(order.updatedAt ?? DateTime.now()),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}