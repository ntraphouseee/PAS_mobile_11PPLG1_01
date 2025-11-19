import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../bindings/favorite_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/product_binding.dart';
import '../bindings/splash_binding.dart';
import '../pages/favorites_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/product_list_page.dart';
import '../pages/profile_page.dart';
import '../pages/register_page.dart';
import '../pages/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(), // Binding khusus untuk Home
    ),
    GetPage(
      name: AppRoutes.PRODUCTS,
      page: () => ProductListPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.FAVORITES,
      page: () => FavoritesPage(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => ProfilePage(),
      binding: AuthBinding(),
    ),
  ];
}