import 'package:get/get.dart';
import 'package:latihan_pas/pages/splash_screen.dart';
import 'package:latihan_pas/pages/login_page.dart';
import 'package:latihan_pas/pages/register_page.dart';
import 'package:latihan_pas/pages/home_page.dart';
import 'package:latihan_pas/pages/product_page.dart';
import 'package:latihan_pas/pages/favorite_page.dart';
import 'package:latihan_pas/pages/profile_page.dart';
import 'package:latihan_pas/bindings/auth_binding.dart';
import 'package:latihan_pas/bindings/splash_binding.dart';
import 'package:latihan_pas/bindings/product_binding.dart';
import 'package:latihan_pas/bindings/favorite_binding.dart';
import 'package:latihan_pas/routes/app_routes.dart';

abstract class AppPages {
  static const INITIAL = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.product,
      page: () => ProductPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.favorite,
      page: () => FavoritePage(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
      binding: AuthBinding(),
    ),
  ];
}