import 'package:get/get.dart';

import '../controllers/pelanggan_controller.dart';

class PelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelangganController>(
      () => PelangganController(),
    );
  }
}
