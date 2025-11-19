import 'package:get/get.dart';
import 'package:pas_mobile_11pplg1_01/controller/auth_controller.dart';
import 'package:pas_mobile_11pplg1_01/routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthController _authController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    print('🎯 SplashController started');
    
    // Tunggu AuthController selesai check login status
    await _authController.checkLoginStatus();
    
    // Delay untuk splash screen effect
    await Future.delayed(Duration(seconds: 2));
    
    print('🎯 Splash - isLoggedIn: ${_authController.isLoggedIn.value}');
    
    if (_authController.isLoggedIn.value) {
      print('🚀 Redirecting to HOME');
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      print('🔐 Redirecting to LOGIN');
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}