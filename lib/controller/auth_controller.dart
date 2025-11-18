import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latihan_pas/routes/app_routes.dart';

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();

  // API Endpoints
  static const String _baseUrl = 'https://mediadwi.com/api/latihan';
  static const String _loginEndpoint = '$_baseUrl/login';
  static const String _registerEndpoint = '$_baseUrl/register-user';

  // Login Function
  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Username and password cannot be empty',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_loginEndpoint),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Get.offAllNamed(AppRoutes.home);
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar('Error', errorData['message'] ?? 'Login failed',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Register Function
  Future<void> register() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();

    if (username.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        email.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_registerEndpoint),
        body: {
          'username': username,
          'password': password,
          'full_name': fullName,
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Registration successful',
            snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed(AppRoutes.login);
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar('Error', errorData['message'] ?? 'Registration failed',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Logout Function
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('Error', 'An error occurred during logout.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    usernameController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}