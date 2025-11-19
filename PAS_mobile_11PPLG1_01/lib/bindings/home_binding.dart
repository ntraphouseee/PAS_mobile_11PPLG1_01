import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/product_controller.dart';
import '../controller/favorite_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    print('🏠 HomeBinding - Initializing controllers for Home');
    
    // Pastikan AuthController sudah ada
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    
    // ProductController untuk product list
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
    
    // FavoriteController untuk favorites
    Get.lazyPut<FavoriteController>(() => FavoriteController(), fenix: true);
    
    print('✅ HomeBinding - All controllers ready');
  }
}