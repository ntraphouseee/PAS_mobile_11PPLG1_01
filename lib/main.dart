import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/auth_binding.dart';
import 'pages/login_page.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key, // Ensure the Overlay is available globally
      initialBinding: AuthBinding(),
      home: SplashPage(), // Set SplashPage as the initial page
    );
  }
}