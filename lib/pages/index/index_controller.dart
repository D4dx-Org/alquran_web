import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/models/juz.dart';
import 'package:alquran_malayalam/helpers/json_helper.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/routes/routes.dart';
import 'package:alquran_malayalam/services/api_service/quran_service.dart';
import 'package:alquran_malayalam/services/surah_services.dart';
import 'package:alquran_malayalam/helpers/settings_helpers.dart';

class IndexController extends GetxController {
  QuranService quranService = QuranService();
  SurahServices surahServices = SurahServices();
  JsonParser jsonParser = JsonParser();
  List<Surah> surahs = [];
  List<Juz> juzList = [];
  bool isLoading = true;
  Rxn<Surah> selectedSurah = Rxn<Surah>();
  RxInt selAyahNo = 1.obs;
  RxBool isSearching = false.obs;
  RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDB();
  }

  loadDB() async {
    try {
      print('Starting to load database...');
      await loadSurahs();
      print('Surahs loaded successfully');
      await loadJuzData();
      print('Juz data loaded successfully');
    } catch (e) {
      print('Error loading database: $e');
      isLoading = false;
      update();
    }
  }

  Surah getSurah(int id) {
    return surahs.singleWhere((element) => element.suraId == id);
  }

  loadSurahs() async {
    try {
      print('Loading surahs...');
      isLoading = true;
      update();

      final List<Surah> list = await surahServices.getSurahs();
      print('Received ${list.length} surahs from service');

      surahs.clear(); // Clear existing data before adding new
      surahs.addAll(list); // Add all surahs to the list

      print('Processed ${surahs.length} surahs');
      isLoading = false;
      if (surahs.isNotEmpty) {
        // Load the last selected surah or default to first surah
        int lastSurahId = SettingsHelpers.instance.getLastSelectedSurah;
        print('Loading last selected surah ID: $lastSurahId');
        selectSurah(getSurah(lastSurahId));
      }
      update();
    } catch (e) {
      print('Error loading surahs: $e');
      isLoading = false;
      update();
      throw e; // Rethrow to handle in loadDB
    }
  }

  loadJuzData() async {
    try {
      print('Loading juz data...');
      isLoading = true;
      update();

      juzList = await jsonParser.loadJuzData();
      print('Loaded ${juzList.length} juz entries');

      isLoading = false;
      update();
    } catch (e) {
      print('Error loading juz data: $e');
      isLoading = false;
      update();
      throw e; // Rethrow to handle in loadDB
    }
  }

  // Get surahs for a specific juz
  List<Surah> getSurahsForJuz(int juzNumber) {
    if (juzList.isEmpty) return [];

    Juz juz = juzList.firstWhere((j) => j.juzNumber == juzNumber);
    List<Surah> juzSurahs = [];

    juz.chapters.forEach((chapterNumber, verseRange) {
      Surah surah = getSurah(chapterNumber);
      juzSurahs.add(surah);
    });

    return juzSurahs;
  }

  selectSurah(Surah surah) async {
    print('Selecting surah: ${surah.suraId} - ${surah.mSuraName}');
    selectedSurah.value = surah;
    // Save the selected surah ID
    SettingsHelpers.instance.lastSelectedSurah(surah.suraId);
    print('Saved selected surah ID: ${surah.suraId}');
  }

  loadSuraDetailPage(int suraId, {int ayaNo = 1}) async {
    Get.toNamed(AppRoutes.TRANLISTING,
        arguments: [suraId, ayaNo], preventDuplicates: false);
  }

  getNavSurah(int shift) {
    int curSuraId = selectedSurah.value!.suraId;
    if (shift == -1 && curSuraId > 1) {
      curSuraId--;
    } else if (shift == 1 && curSuraId <= 113) {
      curSuraId++;
    }
    selectedSurah.value = getSurah(curSuraId);
  }
}
