import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_pas/routes/app_routes.dart';
import 'package:latihan_pas/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}