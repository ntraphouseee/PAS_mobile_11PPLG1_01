import 'dart:convert';
import 'package:get/get.dart';
import 'package:pas_mobile_11pplg1_01/models/user_model.dart';
import 'package:pas_mobile_11pplg1_01/services/api_service.dart';
import 'package:pas_mobile_11pplg1_01/services/local_db_server.dart';
import 'package:pas_mobile_11pplg1_01/routes/app_routes.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var user = User().obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('🔄 AuthController initialized');
    checkLoginStatus();
  }

  Future<bool> checkLoginStatus() async {
    print('🔍 Checking login status...');
    final token = await LocalDbService.getToken();
    final userData = await LocalDbService.getUser();
    
    if (token != null && token.isNotEmpty && userData != null) {
      try {
        isLoggedIn.value = true;
        user.value = User.fromJson(json.decode(userData));
        print('✅ User is logged in: ${user.value.username}');
        return true;
      } catch (e) {
        print('❌ Error parsing user data: $e');
        await logout();
        return false;
      }
    } else {
      print('❌ No user logged in');
      isLoggedIn.value = false;
      return false;
    }
  }

  Future<bool> register(String username, String password, String fullName, String email) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await ApiService.register(username, password, fullName, email);
      
      if (response['status'] == true) {
        isLoading.value = false;
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Unknown error occurred';
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await ApiService.login(username, password);
      
      if (response['status'] == true) {
        final token = response['token'];
        final userData = User(
          username: username,
          email: '$username@example.com',
          fullName: username,
          token: token,
        );
        
        await LocalDbService.saveToken(token);
        await LocalDbService.saveUser(json.encode(userData.toJson()));
        
        user.value = userData;
        isLoggedIn.value = true;
        isLoading.value = false;
        
        print('✅ Login successful! User: $username, Token: ${token.substring(0, 10)}...');
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Login failed';
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Login error: $e';
      isLoading.value = false;
      return false;
    }
  }

  Future<void> logout() async {
    print('🚪 Logging out user: ${user.value.username}');
    
    await LocalDbService.clearAuthData();
    isLoggedIn.value = false;
    user.value = User();
    errorMessage.value = '';
    
    print('✅ User logged out successfully');
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  String? get currentUsername => user.value.username;
}