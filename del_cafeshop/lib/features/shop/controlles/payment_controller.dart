import 'dart:convert';
import 'package:del_cafeshop/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;

Future<String?> createTransaction({
  required String orderId,
  required int amount,
  required String customerName,
}) async {
  final url = Uri.parse('${APIConstants.baseUrl}/admin/payment'); // ganti dengan IP server kamu

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'orderId': orderId,
      'amount': amount,
      'customerName': customerName,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['snapToken'];
  } else {
    print('Gagal membuat transaksi: ${response.body}');
    return null;
  }
}
