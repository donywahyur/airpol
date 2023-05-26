import 'dart:async';

import 'package:airpol/app/modules/admin/controllers/admin_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DaftarPelanggan extends StatefulWidget {
  const DaftarPelanggan({super.key});

  @override
  State<DaftarPelanggan> createState() => _DaftarPelangganState();
}

class _DaftarPelangganState extends State<DaftarPelanggan> {
  final controller = Get.find<AdminController>();

  @override
  void initState() {
    super.initState();
  }

  //onready
  @override
  void didChangeDependencies() {
    controller.streamControllerPelanggan = StreamController<QuerySnapshot>();
    controller.getPelanggan();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.streamControllerPelanggan.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.none) {
              return const Center(child: Text("No connection"));
            } else if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data!.docs;
              if (data.isEmpty) {
                return const Center(child: Text("No data"));
              } else {
                return ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
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
                              Text(
                                data[index]['nama'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: data.length);
              }
            } else {
              return const Center(child: Text("Unknown error"));
            }
          },
          stream: controller.streamControllerPelanggan.stream,
        ),
      ),
    );
  }
}
