import 'package:get/get.dart';
import 'package:latihan_pas/controller/splash_controller.dart';

class SplashscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
