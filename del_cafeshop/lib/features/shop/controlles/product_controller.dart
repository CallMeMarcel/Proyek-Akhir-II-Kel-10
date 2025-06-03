import 'package:get/get.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/data/services/product_service.dart';

class ProductController extends GetxController {
  var allProducts = <Product>[].obs;
  var filteredProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    final products = await ProductService.getProducts();
    allProducts.assignAll(products);
    filteredProducts.assignAll(products);
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(
        allProducts.where((product) => product.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }
}
