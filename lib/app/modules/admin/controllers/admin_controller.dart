import 'dart:async';

import 'package:airpol/app/modules/admin/views/daftar_pelanggan.dart';
import 'package:airpol/app/modules/admin/views/daftar_transaksi.dart';
import 'package:airpol/app/modules/admin/views/setting_harga.dart';
import 'package:airpol/app/modules/admin/views/ganti_password.dart';
import 'package:airpol/app/routes/app_pages.dart';
import 'package:airpol/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminController extends GetxController {
  final loading = false.obs;
  final List menu = [
    'Daftar Transaksi',
    'Daftar Pelanggan',
    'Setting Harga',
    'Ganti Password'
  ];
  final menuIndex = 0.obs;
  late StreamController<QuerySnapshot> streamController =
      StreamController<QuerySnapshot>();

  late StreamController<QuerySnapshot> streamControllerPelanggan =
      StreamController<QuerySnapshot>();
  final db = FirebaseFirestore.instance;
  final search = ''.obs;

  final List<Widget> menuWidget = [
    const DaftarTransaksi(),
    const DaftarPelanggan(),
    const SettingHarga(),
    const GantiPassword()
  ];

  final List<Map<String, dynamic>> listIsian = [];
  final listTransaksi = [].obs;

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('username');
    prefs.remove('nama');
    prefs.remove('isAdmin');
    Get.offAllNamed(Routes.LOGIN);
  }

  changeMenuIndex(int index) {
    menuIndex.value = index;
  }

  getTransaksi() async {
    List<Map<String, dynamic>> listTransaksiMap = [];
    //stream collection merge data transaksi and user where user.id == transaksi.userId firestore
    QuerySnapshot querySnapshot = await db
        .collection('transaksi')
        .orderBy('tanggal', descending: true)
        .get();
    List<QueryDocumentSnapshot> listTransaksi = querySnapshot.docs;
    for (var i = 0; i < listTransaksi.length; i++) {
      Map<String, dynamic> map =
          listTransaksi[i].data() as Map<String, dynamic>;

      //search user by doc id
      DocumentSnapshot doc =
          await db.collection('users').doc(map['userId']).get();
      Map<String, dynamic> mapUser = doc.data() as Map<String, dynamic>;
      map['nama'] = mapUser['nama'];
      listTransaksiMap.add(map);
    }
  }

  getTransaksi2() async {
    loading.value = true;
    listTransaksi.clear();
    QuerySnapshot doc = await db
        .collection('transaksi')
        .orderBy(
          'tanggal',
          descending: false,
        )
        .get();
    doc.docs.forEach((element) async {
      final data = element.data() as Map<String, dynamic>;
      final getUser = await db.collection('users').doc(data['userId']).get();
      final dataUser = getUser.data() as Map<String, dynamic>;
      listTransaksi.add({
        "id": element.id,
        "nama": dataUser['nama'],
        "harga": data['harga'],
        "status": data['status'],
        "tanggal": data['tanggal'],
        "ukuran": data['ukuran'],
        "urlBukti": data['urlBukti'],
      });
    });
    //list transaksi order by tanggal
    listTransaksi.sort((a, b) => b['tanggal'].compareTo(a['tanggal']));
    loading.value = false;
  }

  detailTransaksi(id) async {
    DocumentSnapshot doc = await db.collection('transaksi').doc(id).get();
    Map<String, dynamic> detailTransaksiVal =
        doc.data()! as Map<String, dynamic>;
    return detailTransaksiVal;
  }

  validasiTransaksi(id) async {
    await db.collection('transaksi').doc(id).update({'status': 2});
  }

  getPelanggan() async {
    QuerySnapshot querySnapshot = await db.collection('users').get();
    streamControllerPelanggan.add(querySnapshot);
  }

  getIsian() async {
    loading.value = true;
    listIsian.clear();
    QuerySnapshot doc = await db.collection('isian').get();
    doc.docs.forEach((element) {
      final data = element.data() as Map<String, dynamic>;

      listIsian.add({
        "id": element.id,
        "harga": data['harga'],
        "ukuran": data['ukuran'],
      });
    });
    loading.value = false;
  }

  updateHarga() async {
    loading.value = true;
    for (var i = 0; i < listIsian.length; i++) {
      await db.collection('isian').doc(listIsian[i]['id']).update(listIsian[i]);
    }
    loading.value = false;
    Get.snackbar('Success', 'Berhasil update harga',
        backgroundColor: kPrussianBlue, colorText: Colors.white);
  }

  changePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId')!;
    String password = passwordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi');
    } else if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Password baru dan konfirmasi password tidak sama',
          backgroundColor: kRed, colorText: Colors.white);
    } else {
      try {
        DocumentSnapshot doc = await db.collection('admins').doc(userId).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

          if (data['password'] == password) {
            await db.collection('admins').doc(userId).update({
              'password': newPassword,
            });
            Get.snackbar('Success', 'Password berhasil diubah',
                backgroundColor: kPrussianBlue, colorText: Colors.white);
            passwordController.clear();
            newPasswordController.clear();
            confirmPasswordController.clear();
          } else {
            Get.snackbar('Error', 'Password lama salah',
                backgroundColor: kRed, colorText: Colors.white);
          }
        } else {
          Get.snackbar('Error', 'User tidak ditemukan',
              backgroundColor: kRed, colorText: Colors.white);
        }
      } catch (e) {
        Get.snackbar('Error', 'Terjadi kesalahan $e',
            backgroundColor: kRed, colorText: Colors.white);
      }
    }
  }
}
