import 'package:del_cafeshop/features/shop/controlles/cart_controller.dart';
import 'package:del_cafeshop/features/shop/controlles/product_controller.dart';
import 'package:del_cafeshop/features/shop/controlles/whistlist_controller.dart';
import 'package:get/get.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WishlistController());
    Get.put(CartController());
    Get.put(ProductController());
  }
}