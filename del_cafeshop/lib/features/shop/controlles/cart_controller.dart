import 'package:get/get.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:collection/collection.dart'; // untuk firstWhereOrNull


class CartController extends GetxController {
  final RxList<Product> _cartItems = <Product>[].obs;
  var selectedProducts = <Product>[].obs;
  var isSelectAll = true.obs;


  /// Getter untuk item di cart
  List<Product> get cartItems => _cartItems;

  /// Hitung total harga dari produk yang dipilih
  double get totalHarga => selectedProducts.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity.value),
      );

  /// Jumlah produk yang dipilih
  int get jumlahDipilih => selectedProducts.length;

  /// Tambahkan produk ke cart
  void addToCart(Product product) {
    if (!_cartItems.contains(product)) {
      _cartItems.add(product);
    } else {
      final index = _cartItems.indexOf(product);
      _cartItems[index].quantity.value += product.quantity.value;
    }
    update();
  }

  /// Hapus produk dari cart
  void removeFromCart(Product product) {
    _cartItems.remove(product);
    selectedProducts.remove(product);
    update();
  }

  /// Periksa apakah produk sudah ada di cart
  bool isInCart(Product product) {
    return _cartItems.contains(product);
  }


  /// Kosongkan semua isi cart
  void clearCart() {
    _cartItems.clear();
    selectedProducts.clear();
    update();
  }

  /// Toggle semua pilihan produk
  void toggleSelectAll(bool? value, List<Product> allProducts) {
    isSelectAll.value = value ?? false;
    if (isSelectAll.value) {
      selectedProducts.assignAll(allProducts);
    } else {
      selectedProducts.clear();
    }
    update();
  }



  /// Toggle satu produk dipilih atau tidak
  void toggleItem(Product product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
    update();
  }

  /// Tambah kuantitas produk
  void increaseQuantity(Product product) {
    product.quantity.value++;
    update();
  }

  /// Kurangi kuantitas produk (min 1)
  void decreaseQuantity(Product product) {
    if (product.quantity.value > 1) {
      product.quantity.value--;
      update();
    }
  }

  int getQuantityForProduct(int productId) {
  final product = _cartItems.firstWhereOrNull((p) => p.id == productId);
  return product?.quantity.value ?? 0;
}

 

}
