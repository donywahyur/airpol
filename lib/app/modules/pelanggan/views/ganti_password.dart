import 'package:airpol/app/modules/pelanggan/controllers/pelanggan_controller.dart';
import 'package:airpol/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GantiPassword extends StatefulWidget {
  const GantiPassword({super.key});

  @override
  State<GantiPassword> createState() => _GantiPasswordState();
}

class _GantiPasswordState extends State<GantiPassword> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<PelangganController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Password Lama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.newPasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password Baru tidak boleh kosong';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.confirmPasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password Baru tidak boleh kosong';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.changePassword();
                    }
                  },
                  child: Text('Simpan', style: kTextTheme.subtitle1)),
            ),
          ],
        ),
      ),
    );
  }
}
