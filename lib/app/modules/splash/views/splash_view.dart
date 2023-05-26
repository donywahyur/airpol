import 'package:airpol/constant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<SplashController>(builder: (context) {
          return LiquidLinearProgressIndicator(
            value: controller.animationController.value,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(kPrussianBlue),
            borderRadius: 12.0,
            direction: Axis.vertical,
            center: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/LogoPolinema.png'),
                  Text(
                    'Air Pol',
                    style: TextStyle(
                      color: kPrussianBlue,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
