import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:alquran_malayalam/pages/mushaf/mushaf_controller.dart';
import 'package:get/instance_manager.dart';

class MushafBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<IndexController>()) {
      Get.put<IndexController>(IndexController(), permanent: true);
    }
    Get.lazyPut<MushafController>(() => MushafController());
  }
}
