import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:del_cafeshop/data/models/product.dart';

class WishlistController extends GetxController {
  var wishlistItems = <Product>[].obs;

  static const _wishlistKey = 'wishlist_products';

  @override
  void onInit() {
    super.onInit();
    _loadWishlist();
  }

  void toggleWishlist(Product product) async {
    if (wishlistItems.contains(product)) {
      wishlistItems.remove(product);
    } else {
      wishlistItems.add(product);
    }
    await _saveWishlist();
  }

  bool isWishlisted(Product product) {
    return wishlistItems.contains(product);
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson = prefs.getStringList(_wishlistKey) ?? [];

    final List<Product> loadedProducts = wishlistJson.map((item) {
      final json = jsonDecode(item);
      return Product.fromJson(json);
    }).toList();

    wishlistItems.assignAll(loadedProducts);
  }

  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson = wishlistItems.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_wishlistKey, wishlistJson);
  }
}
