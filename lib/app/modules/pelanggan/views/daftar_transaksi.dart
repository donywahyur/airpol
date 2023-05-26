import 'dart:async';

import 'package:airpol/app/modules/pelanggan/controllers/pelanggan_controller.dart';
import 'package:airpol/app/modules/pelanggan/views/detail_transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DaftarTransaksi extends StatefulWidget {
  const DaftarTransaksi({super.key});

  @override
  State<DaftarTransaksi> createState() => _DaftarTransaksiState();
}

class _DaftarTransaksiState extends State<DaftarTransaksi> {
  final controller = Get.find<PelangganController>();

  @override
  void initState() {
    super.initState();
  }

  //onready
  @override
  void didChangeDependencies() {
    controller.streamController = StreamController<QuerySnapshot>();
    controller.getTransaksi();
    controller.cekAlat();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.sheetAddTransaksi();
        },
        child: const Icon(Icons.local_drink_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.none) {
              return const Center(child: Text("Internet Error"));
            } else if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data!.docs;
              if (data.isEmpty) {
                return const Center(child: Text("Data Kosong"));
              } else {
                return ListView.builder(
                    itemBuilder: (context, index) {
                      final status = data[index]['status'];
                      //change format tanggal to dd mm yy
                      final formatTanggal =
                          DateFormat('dd MMMM yyyy ( hh : mm )')
                              .format(data[index]['tanggal'].toDate());

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DetailTransaksi(
                              idTransaksi: data[index].id,
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
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${formatTanggal}'),
                                  Text(
                                      '${data[index]['ukuran']} ( Rp ${data[index]['harga']} ) '),
                                  Container(
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
                                            style:
                                                TextStyle(color: Colors.white))
                                        : status == 1
                                            ? const Text('Sudah Dibayar',
                                                style: TextStyle(
                                                    color: Colors.white))
                                            : status == 2
                                                ? const Text('Sudah Divalidasi',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                                : Text('Pembayaran Gagal',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                  )
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.deleteTransaksi(data[index].id);
                                },
                                icon: const Icon(Icons.delete),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: data.length);
              }
            } else {
              return const Center(child: Text("Terjadi Kesalahan"));
            }
          },
          stream: controller.streamController.stream,
        ),
      ),
    );
  }
}
