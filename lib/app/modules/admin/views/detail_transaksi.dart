import 'package:airpol/app/modules/admin/controllers/admin_controller.dart';
import 'package:airpol/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailTransaksi extends StatefulWidget {
  const DetailTransaksi({super.key, required this.idTransaksi});
  final String idTransaksi;

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  final controller = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Transaksi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.getTransaksi2();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data as Map<String, dynamic>;
            final status = data['status'];
            final formatTanggal = DateFormat('dd MMMM yyyy ( hh : mm )')
                .format(data['tanggal'].toDate());

            return SingleChildScrollView(
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
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      if (status == 1)
                        GestureDetector(
                          onTap: () async {
                            Get.defaultDialog(
                              title: 'Konfirmasi',
                              middleText:
                                  'Apakah anda yakin ingin validasi transaksi ini?',
                              textConfirm: 'Ya',
                              textCancel: 'Tidak',
                              confirmTextColor: Colors.white,
                              cancelTextColor: kPrussianBlue,
                              onConfirm: () async {
                                await controller
                                    .validasiTransaksi(widget.idTransaksi);
                                Get.back();
                                setState(() {});
                              },
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kPrussianBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Text('Validasi Transaksi',
                                textAlign: TextAlign.center,
                                style: kTextTheme.headline6!
                                    .copyWith(color: Colors.white)),
                          ),
                        )
                    ],
                  )),
            );
          } else {
            return const Center(child: Text('Terjadi Kesalahan'));
          }
        },
        future: controller.detailTransaksi(widget.idTransaksi),
      ),
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
