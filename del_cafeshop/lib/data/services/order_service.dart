import 'dart:convert';
import 'package:del_cafeshop/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:del_cafeshop/data/models/order.dart';

class OrderService {
  static const String orderUrl = '${APIConstants.baseUrl}/admin/orders/index';

  Future<List<Order>> fetchOrders(int userId, {String? token, String? userName}) async {
    try {
      print('OrderService: Fetching orders for userId = $userId, token = $token, userName = $userName');
      // Buat URI dengan query parameter userId jika diperlukan
      final uri = Uri.parse(orderUrl);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      print('Status code = ${response.statusCode}, Body = ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> ordersData = data['orders'] ?? [];
        List<Order> orders = ordersData.map((orderJson) => Order.fromJson(orderJson)).toList();
        List<Order> filteredOrders = orders.where((order) {
          // Filter berdasarkan userId jika tersedia, atau customerName jika tidak
          if (order.userId != null) {
            return order.userId == userId;
          } else {
            return userName != null && order.customerName.toLowerCase() == userName.toLowerCase();
          }
        }).toList();
        print('Found ${filteredOrders.length} orders for userId = $userId');
        return filteredOrders;
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('OrderService error: $e');
      throw Exception('Error fetching orders: $e');
    }
  }
}