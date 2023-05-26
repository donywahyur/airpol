import 'package:airpol/constant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () => controller.toggleAdmin(),
              child: Obx(
                () => Text(
                  controller.isAdmin.value ? 'Login Pelanggan' : 'Login Admin',
                  style: TextStyle(
                    color: kPrussianBlue,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    controller.isDaftar.value
                        ? 'Daftar Pelanggan'
                        : 'Welcome Back !',
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: kPrussianBlue),
                  )),
              const SizedBox(height: 32.0),
              Obx(() => controller.isDaftar.value
                  ? Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                        controller: controller.namaController,
                        decoration: InputDecoration(
                          hintText: 'Nama',
                        ),
                      ),
                    )
                  : Container()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username ',
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.defaultDialog(
                        title: 'Loading',
                        content: CircularProgressIndicator(),
                      );
                      if (controller.isDaftar.value) {
                        controller.daftar();
                      } else {
                        controller.login();
                      }
                    }
                  },
                  child: Obx(() => Text(
                      controller.isDaftar.value ? 'Daftar' : 'Login',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Obx(() => controller.isAdmin.value
                  ? Container()
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.toggleDaftar();
                        },
                        child: Text(
                            controller.isDaftar.value ? 'Login' : 'Daftar',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: kPrussianBlue)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: kPrussianBlue),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                        ),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
