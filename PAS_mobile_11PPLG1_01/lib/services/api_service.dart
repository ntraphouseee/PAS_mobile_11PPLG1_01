import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://mediadwi.com/api/latihan';
  static const String _fakeStoreUrl = 'https://fakestoreapi.com';

  static Future<Map<String, dynamic>> register(
      String username, String password, String fullName, String email) async {
    try {
      print('🌐 Sending registration request to: $_baseUrl/register-user');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/register-user'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
          'full_name': fullName,
          'email': email,
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return json.decode(response.body);
    } catch (e) {
      print('💥 API Error: $e');
      return {
        'status': false,
        'message': 'Network error: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🌐 Sending login request to: $_baseUrl/login');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return json.decode(response.body);
    } catch (e) {
      print('💥 API Error: $e');
      return {
        'status': false,
        'message': 'Network error: $e'
      };
    }
  }

  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('$_fakeStoreUrl/products'));
    return json.decode(response.body);
  }
}