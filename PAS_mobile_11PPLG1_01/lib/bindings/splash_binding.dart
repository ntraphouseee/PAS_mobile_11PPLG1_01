import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
  }
}