import 'dart:convert';
import 'package:del_cafeshop/navigation_menu.dart';
import 'package:del_cafeshop/user_provider.dart';
import 'package:del_cafeshop/utils/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = false.obs;
  final formKey = GlobalKey<FormState>();
  final isPasswordVisible = false.obs;

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Peringatan', 'Email dan password wajib diisi');
      return;
    }

    final url = Uri.parse('${APIConstants.baseUrl}/user/login');

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('AuthController: Login response status = ${res.statusCode}, body = ${res.body}');

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final user = data['user'];
        final token = data['token'];

        Provider.of<UserProvider>(context, listen: false).setUser(
          userId: user['id'],
          token: token,
          name: user['name'],
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', user['id'].toString());
        await prefs.setString('email', user['email']);
        await prefs.setString('name', user['name']); // Gunakan 'name', bukan 'username'
        await prefs.setString('auth_token', token);

        if (rememberMe.value) {
          await prefs.setBool('rememberMe', true);
        }

        print('Auth token disimpan: ${prefs.getString('auth_token')}');

        clearForm();
        Get.snackbar('Sukses', 'Login berhasil');
        Get.offAll(() => const NavigationMenu());
      } else {
        Get.snackbar('Login Gagal', data['message'] ?? 'Email atau password salah');
      }
    } catch (e) {
      print('Login error: $e');
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    rememberMe.value = false;
    isPasswordVisible.value = false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    clearForm();
    Get.offAllNamed('/login');
  }

  Future<Map<String, String?>> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString('id'),
      'email': prefs.getString('email'),
      'name': prefs.getString('name'),
      'auth_token': prefs.getString('auth_token'),
    };
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}