import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = 'https://mediadwi.com/api/latihan';

  // Method untuk Form Data (x-www-form-urlencoded)
  Future<Map<String, dynamic>> postFormData({
    required String endpoint,
    required Map<String, String> body,
  }) async {
    try {
      final url = '$baseUrl/$endpoint';
      print('🌐 API Request to: $url');
      print('📦 Request body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: body,
      );

      print('📡 Response status: ${response.statusCode}');
      print('📨 Response body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);
      responseData['statusCode'] = response.statusCode;

      return responseData;
    } catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: $e');
    }
  }

  // Method untuk JSON (sebagai backup)
  Future<Map<String, dynamic>> postJson({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      final url = '$baseUrl/$endpoint';
      print('🌐 API Request to: $url');
      print('📦 Request body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📨 Response body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);
      responseData['statusCode'] = response.statusCode;

      return responseData;
    } catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: $e');
    }
  }
}