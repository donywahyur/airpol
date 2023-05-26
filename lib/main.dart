import 'package:airpol/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:airpol/constant.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      //set blue theme
      theme: ThemeData.light().copyWith(
        primaryColor: kPrussianBlue,
        textTheme:
            kTextTheme.apply(bodyColor: kRichBlack, displayColor: kRichBlack),
        colorScheme: kColorScheme,
      ),
    ),
  );
}
