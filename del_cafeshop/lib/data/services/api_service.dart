// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:del_cafeshop/data/models/user.dart';

class ApiService {
  static const String baseUrl = 'http://172.27.81.227:8000';
  static const String profileEndpoint = '/user/profile';
  static const String uploadImageEndpoint = '/user/upload-profile-image';

  Future<User> fetchUserProfile(String token) async {
    print('Mengirim token: $token');
    final response = await http.get(
      Uri.parse('$baseUrl$profileEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status kode: ${response.statusCode}');
    print('Respons body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData['data']);
    } else {
      throw Exception('Gagal memuat profil: ${response.statusCode}');
    }
  }

  Future<User> updateUserProfile({
    required String token,
    required String name,
    required String email,
    required String phone,
    String? imageUrl,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$profileEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'image_url': imageUrl ?? '',
      }),
    );

    print('Update status kode: ${response.statusCode}');
    print('Update respons body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData['data']);
    } else {
      throw Exception('Gagal memperbarui profil: ${response.statusCode}');
    }
  }

  Future<String> uploadProfileImage(String token, File image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$uploadImageEndpoint'));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print('Upload status kode: ${response.statusCode}');
    print('Upload respons body: $responseBody');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(responseBody);
      return jsonData['data']['image_url'] as String;
    } else {
      throw Exception('Gagal mengunggah gambar: ${response.statusCode}');
    }
  }
}