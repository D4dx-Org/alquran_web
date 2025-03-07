import 'package:alquran_malayalam/pages/settings/settings_controller.dart';
import 'package:get/instance_manager.dart';
import 'package:alquran_malayalam/pages/tranlisting/tranlisting_controller.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';

class TranListingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<IndexController>()) {
      Get.put<IndexController>(IndexController(), permanent: true);
    }
    if (!Get.isRegistered<SettingsController>()) {
      Get.put<SettingsController>(SettingsController(), permanent: true);
    }
    Get.lazyPut<TranListingController>(() => TranListingController());
  }
}
