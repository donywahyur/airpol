import 'dart:async';

import 'package:airpol/app/modules/admin/controllers/admin_controller.dart';
import 'package:airpol/app/modules/admin/views/detail_transaksi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DaftarTransaksi extends StatefulWidget {
  const DaftarTransaksi({super.key});

  @override
  State<DaftarTransaksi> createState() => _DaftarTransaksiState();
}

class _DaftarTransaksiState extends State<DaftarTransaksi> {
  final controller = Get.find<AdminController>();

  @override
  void didChangeDependencies() {
    controller.getTransaksi2();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.getTransaksi2();
          },
          child: const Icon(Icons.refresh)),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() => controller.loading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.listTransaksi.length == 0
                  ? const Center(
                      child: Text('Data Transaksi Kosong'),
                    )
                  : ListView.builder(
                      itemCount: controller.listTransaksi.length,
                      itemBuilder: (context, index) {
                        final data = controller.listTransaksi[index];
                        final status = data['status'];
                        final formatTanggal =
                            DateFormat('dd MMMM yyyy ( HH:mm )')
                                .format(data['tanggal'].toDate());
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailTransaksi(
                                idTransaksi: data['id'],
                              );
                            }));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Pelanggan : ${data['nama']}'),
                                    Text('${formatTanggal}'),
                                    Text(
                                        '${data['ukuran']} ( Rp ${data['harga']} ) '),
                                  ],
                                ),
                                Container(
                                  width: 110,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: status == 0
                                        ? Colors.red
                                        : status == 1
                                            ? Colors.orange
                                            : status == 2
                                                ? Colors.green
                                                : Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: const EdgeInsets.only(top: 16),
                                  child: status == 0
                                      ? const Text('Belum Dibayar',
                                          style: TextStyle(color: Colors.white))
                                      : status == 1
                                          ? const Text('Sudah Dibayar',
                                              style: TextStyle(
                                                  color: Colors.white))
                                          : status == 2
                                              ? const Text('Sudah Divalidasi',
                                                  style: TextStyle(
                                                      color: Colors.white))
                                              : const Text('Pembayaran Gagal',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                )
                                // IconButton(
                                //   onPressed: () {
                                //     // controller.deleteTransaksi(data[index].id);
                                //   },
                                //   icon: const Icon(Icons.delete),
                                // )
                              ],
                            ),
                          ),
                        );
                      }))),
    );
  }
}
