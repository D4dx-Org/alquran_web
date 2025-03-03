import 'package:alquran_malayalam/pages/mushaf/mushaf_controller.dart';
import 'package:get/instance_manager.dart';

class MushafBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MushafController>(() => MushafController());
  }
}
