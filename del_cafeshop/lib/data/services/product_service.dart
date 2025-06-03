import 'dart:convert';
import 'package:del_cafeshop/data/models/category.dart';
import 'package:del_cafeshop/data/models/product.dart';
import 'package:del_cafeshop/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String _baseUrl = '${APIConstants.baseUrl}/admin/product';

  static Future<List<Product>> getProducts() async {
    final Uri url = Uri.parse('$_baseUrl/index');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load products: ${response.statusCode}');
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> productsData = responseData['data'];

      if (productsData is! List) {
        throw Exception('Invalid data format: expected a list');
      }

      return productsData.map<Product>((productJson) {
        try {
          return Product.fromJson(productJson);
        } catch (e, stackTrace) {
          print('Error parsing product: $e\n$stackTrace');
          
          return _defaultProduct();
        }
      }).toList();

    } catch (e, stackTrace) {
      print('Failed to fetch products: $e\n$stackTrace');
      throw Exception('Failed to fetch products: $e');
    }
  }

  static Product _defaultProduct() {
    return Product(
      id: 0,
      name: 'Unknown',
      description: '',
      status: 'available',
      title: 'Unknown Product',
      price: 0.0,
      image: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      categoryId: 0,
      category: Category(id: 0, name: 'Uncategorized'),
    );
  }

  /// Method baru untuk mengambil produk berdasarkan kategori
  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      // Ambil semua produk terlebih dahulu
      final allProducts = await getProducts();
      
      // Filter produk berdasarkan categoryId
      return allProducts.where((product) => product.categoryId == categoryId).toList();
    } catch (e) {
      print('Error filtering products by category: $e');
      throw Exception('Failed to filter products by category: $e');
    }
  }
}
