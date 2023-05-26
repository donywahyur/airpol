import 'package:airpol/app/routes/app_pages.dart';
import 'package:airpol/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final isAdmin = false.obs;
  final isDaftar = false.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  final db = FirebaseFirestore.instance;

  void toggleAdmin() {
    isAdmin.value = !isAdmin.value;
    if (isAdmin.value == true) {
      isDaftar.value = false;
    }
  }

  void toggleDaftar() {
    isDaftar.value = !isDaftar.value;
  }

  bool isValidEmail(String value) {
    // Define a regex pattern to validate email addresses
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    // Check if the entered value matches the expected email format
    if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  clearText() {
    usernameController.clear();
    passwordController.clear();
    namaController.clear();
  }

  void login() async {
    late List<DocumentSnapshot> documents;
    if (isAdmin.value) {
      final QuerySnapshot result = await db
          .collection('admins')
          .where('username', isEqualTo: usernameController.text)
          .where('password', isEqualTo: passwordController.text)
          .get();
      documents = result.docs;
    } else {
      final QuerySnapshot result = await db
          .collection('users')
          .where('username', isEqualTo: usernameController.text)
          .where('password', isEqualTo: passwordController.text)
          .get();
      documents = result.docs;
    }

    if (documents.length == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', documents[0].id);
      prefs.setString('username', documents[0]['username']);
      prefs.setString('nama', documents[0]['nama']);
      prefs.setBool('isAdmin', isAdmin.value);

      clearText();
      Get.back();
      Get.snackbar(
        'Login',
        'Berhasil Login',
        colorText: Colors.white,
        backgroundColor: kPrussianBlue,
      );
      if (isAdmin.value) {
        Get.offAndToNamed(Routes.ADMIN);
      } else {
        Get.offAndToNamed(Routes.PELANGGAN);
      }
    } else {
      Get.back();
      Get.snackbar('Login', 'Username atau Password salah',
          colorText: Colors.white, backgroundColor: kRed);
    }
  }

  void daftar() async {
    //cek username in firestore
    final QuerySnapshot result = await db
        .collection('users')
        .where('username', isEqualTo: usernameController.text)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      Get.back();
      Get.snackbar(
        'Daftar',
        'Username sudah terdaftar',
        colorText: Colors.white,
        backgroundColor: kRed,
      );
      return;
    }

    await db.collection('users').add({
      'nama': namaController.text,
      'username': usernameController.text,
      'password': passwordController.text,
    });
    clearText();
    Get.back();
    Get.snackbar(
      'Daftar',
      'Berhasil Daftar',
      colorText: Colors.white,
      backgroundColor: kPrussianBlue,
    );
  }
}
