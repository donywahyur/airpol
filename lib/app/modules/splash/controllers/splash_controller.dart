import 'package:airpol/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement SplashController

  late AnimationController animationController;

  @override
  void onInit() async {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animationController.forward();
    animationController.addListener(() async {
      update();
      if (animationController.isCompleted) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('userId') != null) {
          if (prefs.getBool('isAdmin') == true) {
            Get.offNamed(Routes.ADMIN);
          } else {
            Get.offNamed(Routes.PELANGGAN);
          }
        } else {
          Get.offNamed(Routes.LOGIN);
        }
      }
    });
  }
}
