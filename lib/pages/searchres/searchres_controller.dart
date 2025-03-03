import 'package:alquran_malayalam/helpers/settings_helpers.dart';
import 'package:alquran_malayalam/models/transl.dart';
import 'package:alquran_malayalam/routes/routes.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/services/tranlisting_services.dart';

class SearchResController extends GetxController {
  RxString queryStr = ''.obs;

  Rx<double> fontSizeMalayalam =
      SettingsHelpers.instance.getFontSizeMalayalam!.obs;

  TranListingServices searchServices = TranListingServices();

  List<TranLine> tranLineList = [];

  bool isLoading = true;
  bool isTransLoading = true;
  bool isIntptrLoading = true;
  bool isQuranLoading = true;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDB();

    queryStr.listen((querystr) async {
      if (querystr.isNotEmpty) {
        await loadTranSearchRes(querystr);
      }
    });
  }

  loadDB() async {
    var data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      queryStr.value = data[0];
      if (queryStr.value.isNotEmpty) {
        await loadTranSearchRes(queryStr.value);
      }
    }
  }

  loadTranSearchRes(String schStr) async {
    try {
      print('SearchResController: Starting search for "$schStr"');
      isLoading = true;
      hasError.value = false;
      errorMessage.value = '';
      tranLineList = [];
      update();

      List<TranLine> results =
          await searchServices.getSearchTranLines(queryString: schStr);
      print('SearchResController: Found ${results.length} results');

      tranLineList = results;
      isLoading = false;
      update();
    } catch (e) {
      print('SearchResController: Error during search: $e');
      hasError.value = true;
      errorMessage.value = 'Search failed. Please try again.';
      isLoading = false;
      update();

      Get.snackbar(
        'Search Error',
        'Failed to perform search. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    }
  }

  showSuraTranLines(int suraId, int ayaNo) async {
    await Get.toNamed(AppRoutes.TRANLISTING,
        arguments: [suraId, ayaNo], preventDuplicates: false);
  }
}
