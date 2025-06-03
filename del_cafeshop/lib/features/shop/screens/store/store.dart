import 'package:del_cafeshop/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:del_cafeshop/features/shop/controlles/product_controller.dart';
import 'package:del_cafeshop/features/shop/screens/store/widgets/category.dart';
import 'package:del_cafeshop/features/shop/screens/store/widgets/category_class.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Tambahkan jika menggunakan GetX

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final productController = Get.put(ProductController());


    return DefaultTabController(
      length: 2,
      child: Scaffold(
                appBar: AppBar(
          title: Text(
            'Store',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true, 
          actions: [
             CartCounterIcon(
              onPressed: () {},
              iconColor: isDark ? Colors.white : Colors.black,

        ),
          ],
        ),

        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              CategoryClass(isDark: isDark),

            ];
          },
          body: const TabBarView(
            children: [
              CategoryTab(),
            ],
          ),
        ),
      ),
    );
  }
}
