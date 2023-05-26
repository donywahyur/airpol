import 'package:airpol/constant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pelanggan_controller.dart';

class PelangganView extends GetView<PelangganController> {
  const PelangganView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: kPrussianBlue,
        child: ListView(
          children: [
            ListTile(
              title: Text('AIR POL - PELANGGAN', style: kTextTheme.headline5),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1,
            ),
            ListTile(
              title: const Text('Daftar Transaksi'),
              onTap: () {
                controller.changeMenuIndex(0);
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Ganti Password'),
              onTap: () {
                controller.changeMenuIndex(1);
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
                Get.back();
                controller.logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Obx(() => Text(controller.menu[controller.menuIndex.value])),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.menuWidget[controller.menuIndex.value];
      }),
    );
  }
}
