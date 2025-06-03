import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:del_cafeshop/utils/constants/api_constants.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String createdAt;
  final String? imageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      createdAt: json['created_at'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'created_at': createdAt,
        'image_url': imageUrl,
      };
}

class ProfileController extends GetxController {
  final user = Rx<User?>(null);
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      print('Token di ProfileController: $token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse('${APIConstants.baseUrl}/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Fetch profile status: ${response.statusCode}');
      print('Fetch profile response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        user.value = User.fromJson(data);
      } else if (response.statusCode == 401) {
        await prefs.remove('auth_token');
        Get.offAllNamed('/login');
        Get.snackbar('Sesi Habis', 'Silakan login kembali');
      } else if (response.statusCode == 404) {
        Get.snackbar('Error', 'Endpoint profil tidak ditemukan. Hubungi admin.');
      } else {
        Get.snackbar('Error', 'Gagal memuat profil: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch profile error: $e');
      Get.snackbar('Error', 'Terjadi kesalahan saat memuat profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadProfileImage(File image) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${APIConstants.baseUrl}/user/upload-profile-image'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Upload image status: ${response.statusCode}');
      print('Upload image response: $responseBody');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody)['data'];
        final newImageUrl = data['image_url'];
        if (user.value != null) {
          user.value = User(
            id: user.value!.id,
            name: user.value!.name,
            email: user.value!.email,
            phone: user.value!.phone,
            createdAt: user.value!.createdAt,
            imageUrl: newImageUrl,
          );
          user.refresh();
        }
        Get.snackbar('Sukses', 'Foto profil berhasil diunggah');
      } else {
        try {
          final errorData = jsonDecode(responseBody);
          Get.snackbar('Error', 'Gagal mengunggah foto: ${errorData['message'] ?? 'Unknown error'}');
        } catch (_) {
          Get.snackbar('Error', 'Gagal mengunggah foto: ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      print('Upload image error: $e');
      Get.snackbar('Error', 'Terjadi kesalahan saat mengunggah foto: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? imageUrl,
  }) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.put(
        Uri.parse('${APIConstants.baseUrl}/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
        }),
      );

      print('Update profile status: ${response.statusCode}');
      print('Update profile response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        user.value = User(
          id: user.value!.id,
          name: data['name'] ?? name,
          email: data['email'] ?? email,
          phone: data['phone'] ?? phone,
          createdAt: user.value!.createdAt,
          imageUrl: imageUrl ?? user.value!.imageUrl,
        );
        user.refresh();
        Get.snackbar('Sukses', 'Profil berhasil diperbarui');
        Get.back();
      } else {
        try {
          final errorData = jsonDecode(response.body);
          Get.snackbar('Error', 'Gagal memperbarui profil: ${errorData['message'] ?? 'Unknown error'}');
        } catch (_) {
          Get.snackbar('Error', 'Gagal memperbarui profil: ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      print('Update profile error: $e');
      Get.snackbar('Error', 'Terjadi kesalahan saat memperbarui profil: $e');
    } finally {
      isLoading.value = false;
    }
  }
}