import 'package:airpol/app/modules/admin/controllers/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingHarga extends StatefulWidget {
  const SettingHarga({super.key});

  @override
  State<SettingHarga> createState() => _SettingHargaState();
}

class _SettingHargaState extends State<SettingHarga> {
  final controller = Get.find<AdminController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    controller.getIsian();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loading.value
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ListView.builder(
                    itemBuilder: (context, index) {
                      final data = controller.listIsian[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index > 0)
                              const Divider(
                                color: Colors.black,
                              ),
                            Text("Ukuran ${data['ukuran']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            TextFormField(
                              onSaved: (value) {
                                data['harga'] = value;
                              },
                              initialValue: data['harga'].toString(),
                              decoration: const InputDecoration(
                                  labelText: "Harga",
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Tidak boleh kosong";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: controller.listIsian.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          controller.updateHarga();
                        }
                      },
                      child: const Text("Simpan"),
                    ),
                  )
                ],
              ),
            )));
  }
}
