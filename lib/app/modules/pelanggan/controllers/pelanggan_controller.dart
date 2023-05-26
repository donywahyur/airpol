import 'dart:async';

import 'package:airpol/app/modules/pelanggan/views/daftar_transaksi.dart';
import 'package:airpol/app/modules/pelanggan/views/ganti_password.dart';
import 'package:airpol/app/routes/app_pages.dart';
import 'package:airpol/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PelangganController extends GetxController {
  final db = FirebaseFirestore.instance;
  late StreamSubscription streamPegisian;

  final DatabaseReference realtime_db = FirebaseDatabase.instance.ref();
  final List menu = ['Daftar Transaksi', 'Ganti Password'];
  final menuIndex = 0.obs;
  final List<Widget> menuWidget = [DaftarTransaksi(), GantiPassword()];
  final ukuranValue = ''.obs;
  final pembayaranValue = 0.obs;
  Map<String, dynamic> detailTransaksiVal = Map<String, dynamic>();
  final loading = false.obs;
  final alatValue = true.obs; //bisa digunakan untuk transaksi tunai

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late StreamController<QuerySnapshot> streamController =
      StreamController<QuerySnapshot>();

  @override
  void onInit() {
    super.onInit();
  }

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
        DocumentSnapshot doc = await db.collection('users').doc(userId).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

          if (data['password'] == password) {
            await db.collection('users').doc(userId).update({
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
        Get.snackbar('Error', 'Terjadi kesalahan',
            backgroundColor: kRed, colorText: Colors.white);
      }
    }
  }

  getTransaksi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId')!;
    streamController.addStream(db
        .collection('transaksi')
        .where('userId', isEqualTo: userId)
        .orderBy('tanggal', descending: true)
        .snapshots());
  }

  sheetAddTransaksi() async {
    List<Expanded> items = [];
    QuerySnapshot snapshot = await db.collection('isian').get();
    snapshot.docs.forEach((doc) {
      items.add(Expanded(
        flex: 5,
        child: GestureDetector(
          onTap: () {
            ukuranValue.value = doc.id;
          },
          child: Obx(() => Container(
                alignment: Alignment.center,
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: kPrussianBlue),
                  color: ukuranValue.value == doc.id
                      ? kPrussianBlue
                      : Colors.white,
                ),
                child: Text('${doc['ukuran']}\nRp ${doc['harga']}',
                    textAlign: TextAlign.center,
                    style: kTextTheme.headline6!.copyWith(
                        color: ukuranValue.value == doc.id
                            ? Colors.white
                            : kPrussianBlue)),
              )),
        ),
      ));
    });

    List<Expanded> pembayaran = [];
    pembayaran.add(Expanded(
      flex: 5,
      child: GestureDetector(
        onTap: () {
          pembayaranValue.value = 1;
        },
        child: Obx(() => Container(
              alignment: Alignment.center,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: kPrussianBlue),
                color:
                    pembayaranValue.value == 1 ? kPrussianBlue : Colors.white,
              ),
              child: Text('Non Tunai',
                  textAlign: TextAlign.center,
                  style: kTextTheme.headline6!.copyWith(
                      color: pembayaranValue.value == 1
                          ? Colors.white
                          : kPrussianBlue)),
            )),
      ),
    ));

    pembayaran.add(Expanded(
      flex: 5,
      child: GestureDetector(
        onTap: () {
          pembayaranValue.value = 2;
        },
        child: Obx(() => Container(
              alignment: Alignment.center,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: kPrussianBlue),
                color:
                    pembayaranValue.value == 2 ? kPrussianBlue : Colors.white,
              ),
              child: Text('Tunai',
                  textAlign: TextAlign.center,
                  style: kTextTheme.headline6!.copyWith(
                      color: pembayaranValue.value == 2
                          ? Colors.white
                          : kPrussianBlue)),
            )),
      ),
    ));

    Get.bottomSheet(
      Container(
        height: 450,
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tambah Transaksi',
              style:
                  kTextTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            //radio button
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: Text('Ukuran', style: kTextTheme.headline6)),
            Row(
              children: items,
            ),
            const SizedBox(height: 10),
            //radio button
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: Text('Jenis Pembayaran', style: kTextTheme.headline6)),
            Row(
              children: pembayaran,
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  if (ukuranValue.value == '') {
                    Get.snackbar('Error', 'Pilih ukuran terlebih dahulu',
                        backgroundColor: kRed, colorText: Colors.white);
                    return;
                  }

                  if (pembayaranValue.value == 0) {
                    Get.snackbar(
                        'Error', 'Pilih jenis pembayaran terlebih dahulu',
                        backgroundColor: kRed, colorText: Colors.white);
                    return;
                  }
                  // print(alatValue.value);
                  if (alatValue.value == false && pembayaranValue.value == 2) {
                    //tunai dan alat sedang digunakan
                    Get.snackbar('Error', 'Alat sedang digunakan',
                        backgroundColor: kRed, colorText: Colors.white);
                    return;
                  }

                  //show dialog confirm
                  Get.defaultDialog(
                    title: 'Konfirmasi',
                    middleText: 'Apakah anda yakin ingin membeli?',
                    textConfirm: 'Ya',
                    textCancel: 'Tidak',
                    confirmTextColor: Colors.white,
                    cancelTextColor: kPrussianBlue,
                    onConfirm: () {
                      addTransaksi(ukuranValue.value, pembayaranValue.value);
                      Get.back();
                      Get.back();
                    },
                  );
                },
                child: Text('Beli',
                    style: kTextTheme.subtitle1!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addTransaksi(ukuran, pembayaran) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId')!;

    try {
      final isian = await db.collection('isian').doc(ukuran).get();

      int kode = 0;
      if (isian['ukuran'] == '300ml') {
        kode = 1;
      } else {
        kode = 2;
      }
      if (pembayaran == 2) {
        kode += 2;
      }

      Map<String, dynamic> data = isian.data()! as Map<String, dynamic>;
      DocumentReference docRef = await db.collection('transaksi').add({
        'userId': userId,
        'ukuran': isian['ukuran'],
        'harga': isian['harga'],
        'tanggal': DateTime.now(),
        'urlBukti': '',
        'jenisPembayaran': pembayaran,
        'status': 0,
      });

      // //update data to realtime database firebase
      // await db
      //     .collection('users')
      //     .doc(userId)
      //     .update({'saldo': FieldValue.increment(-data['harga'])});
      if (pembayaran == 2) {
        ubahDataAlat(kode, 0);
        streamPengisian(docRef.id);
      }
      Get.snackbar('Success', 'Transaksi berhasil dibuat',
          backgroundColor: kPrussianBlue, colorText: Colors.white);

      ukuranValue.value = '';
      pembayaranValue.value = 0;
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan ${e.toString()}',
          backgroundColor: kRed, colorText: Colors.white);
    }
  }

  cekAlat() {
    realtime_db
        .child('UsersData/TBAr7PqT1xYXT7eiFxRPf5IHBFC3')
        .onValue
        .listen((event) {
      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;
      if (data['Kode'] != 0) {
        alatValue.value = false;
      } else {
        alatValue.value = true;
      }
      // print('${alatValue.value} - ${data['Kode']}');
    });
    // print('${alatValue.value}');
  }

  streamPengisian(docId) async {
    //get value from realtime database firebase
    streamPegisian = realtime_db
        .child('UsersData/TBAr7PqT1xYXT7eiFxRPf5IHBFC3')
        .onValue
        .listen((event) {
      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;
      if (data['Status'] == 1) {
        print('Transaksi Berhasil');
        //update firestore data by doc
        streamPegisian.cancel();
        db.collection('transaksi').doc(docId).update({
          'status': 2, //transaksi berhasil tanpa validasi manual admin
        });
        ubahDataAlat(0, 0);
        return;
      }
    });

    Timer(const Duration(seconds: 10), () {
      streamPegisian.cancel();
      print('Transaksi Gagal / Timeout');
      db.collection('transaksi').doc(docId).update({
        'status': 3, //transaksi gagal
      });
      ubahDataAlat(0, 0);
    });
  }

  ubahDataAlat(kode, status) {
    realtime_db
        .child('UsersData/TBAr7PqT1xYXT7eiFxRPf5IHBFC3')
        .update({'Kode': kode, 'Status': status});
  }

  deleteTransaksi(id) async {
    //show dialog confirm
    Get.defaultDialog(
      title: 'Konfirmasi',
      middleText: 'Apakah anda yakin ingin membeli?',
      textConfirm: 'Ya',
      textCancel: 'Tidak',
      confirmTextColor: Colors.white,
      cancelTextColor: kPrussianBlue,
      onConfirm: () async {
        Get.back();
        Get.back();
        try {
          await db.collection('transaksi').doc(id).delete();
          //delete storage
          Reference ref = FirebaseStorage.instance.ref().child('bukti/$id');
          if (ref != null) await ref.delete();

          Get.snackbar('Success', 'Transaksi berhasil dihapus',
              backgroundColor: kPrussianBlue, colorText: Colors.white);
        } catch (e) {
          // Get.snackbar('Error', 'Terjadi kesalahan ${e.toString()}',
          //     backgroundColor: kRed, colorText: Colors.white);
        }
      },
    );
  }

  detailTransaksi(id) async {
    loading.value = true;
    DocumentSnapshot doc = await db.collection('transaksi').doc(id).get();
    detailTransaksiVal = doc.data()! as Map<String, dynamic>;
    loading.value = false;
  }

  uploadFile(id, file) async {
    loading.value = true;
    try {
      Reference ref = FirebaseStorage.instance.ref().child('bukti/$id');
      await ref.putFile(file);
      String url = await ref.getDownloadURL();
      await db.collection('transaksi').doc(id).update({
        'urlBukti': url,
        'status': 1,
      });
      await detailTransaksi(id);
      Get.snackbar('Success', 'Bukti berhasil diupload',
          backgroundColor: kPrussianBlue, colorText: Colors.white);
      loading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan',
          backgroundColor: kRed, colorText: Colors.white);
      loading.value = false;
    }
  }
}
