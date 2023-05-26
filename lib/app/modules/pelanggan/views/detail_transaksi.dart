import 'dart:io';

import 'package:airpol/app/modules/pelanggan/controllers/pelanggan_controller.dart';
import 'package:airpol/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class DetailTransaksi extends StatefulWidget {
  const DetailTransaksi({super.key, required this.idTransaksi});
  final String idTransaksi;

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  final controller = Get.find<PelangganController>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.detailTransaksi(widget.idTransaksi);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.loading.value) {
          return Scaffold(
              body: const Center(child: CircularProgressIndicator()));
        } else {
          final status = controller.detailTransaksiVal['status'];
          //change format tanggal to dd mm yy
          final formatTanggal = DateFormat('dd MMMM yyyy ( hh : mm )')
              .format(controller.detailTransaksiVal['tanggal'].toDate());

          final data = controller.detailTransaksiVal;

          return Scaffold(
              appBar: AppBar(
                title: const Text("Detail Transaksi"),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  //refresh
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      controller.detailTransaksi(widget.idTransaksi);
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabel(
                          label: "Tanggal",
                          value: formatTanggal,
                        ),
                        TextLabel(
                          label: "Ukuran",
                          value: data['ukuran'],
                        ),
                        TextLabel(
                          label: "Harga",
                          value: "Rp ${data['harga'].toString()}",
                        ),
                        TextLabel(
                          label: "Jenis Pembayaran",
                          value: data['jenisPembayaran'] == 1
                              ? "Non Tunai"
                              : "Tunai",
                        ),
                        if (data['jenisPembayaran'] == 1)
                          Text('Bukti', style: kTextTheme.headline6!),
                        if (data['urlBukti'] != "")
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            //image network with border radius
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data['urlBukti'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if (data['status'] < 2 && data['jenisPembayaran'] == 1)
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              color: kPrussianBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png', 'jpeg'],
                                );
                                if (result != null) {
                                  // print(result);
                                  controller.uploadFile(
                                      widget.idTransaksi,
                                      File(
                                          result.files.single.path.toString()));
                                } else {
                                  // User canceled the picker
                                }
                              },
                              child: Text(
                                'Upload File',
                                style: kTextTheme.headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
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
                              ? Text('Belum Dibayar',
                                  style: kTextTheme.headline6!
                                      .copyWith(color: Colors.white))
                              : status == 1
                                  ? Text('Sudah Dibayar',
                                      style: kTextTheme.headline6!
                                          .copyWith(color: Colors.white))
                                  : status == 2
                                      ? Text('Sudah Divalidasi',
                                          style: kTextTheme.headline6!
                                              .copyWith(color: Colors.white))
                                      : Text('Pembayaran Gagal',
                                          style: kTextTheme.headline6!
                                              .copyWith(color: Colors.white)),
                        )
                      ],
                    )),
              ));
        }
      },
    );
  }
}

class TextLabel extends StatelessWidget {
  const TextLabel({
    Key? key,
    this.label,
    this.value,
  }) : super(key: key);
  final label;
  final value;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('${label}', style: kTextTheme.headline6!),
      SizedBox(height: 10),
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kPrussianBlue)),
        child: Text('${value}', style: kTextTheme.headline6),
      )
    ]);
  }
}
