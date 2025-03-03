import 'package:get/get.dart';
import 'package:alquran_malayalam/services/api_service/quran_com_service.dart';
import 'package:alquran_malayalam/models/verse_model.dart';
import 'package:alquran_malayalam/helpers/json_helper.dart';

class MushafController extends GetxController {
  final QuranComService _quranService = QuranComService();
  final JsonParser _jsonParser = JsonParser();

  // Store verses by page number
  final RxMap<int, List<QuranVerse>> versesByPage =
      <int, List<QuranVerse>>{}.obs;
  RxInt currentPage = 1.obs;
  RxInt currentSurah = 1.obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  RxBool hasMorePages = true.obs;

  Map<int, List<int>>? pageToSurahMap;
  Map<int, String>? surahNames;

  @override
  void onInit() {
    super.onInit();
    print('🚀 MushafController initialized');
    initializeController();
  }

  Future<void> initializeController() async {
    try {
      await loadPageToSurahMapping();
      await loadSurahNames();
      print('🔄 Initial fetch started');
      updateSurahForPage(currentPage.value);
      await loadNextPages();
    } catch (e) {
      print('❌ Error initializing controller: $e');
      error.value = 'Error initializing: $e';
    }
  }

  Future<void> loadSurahNames() async {
    try {
      print('📚 Loading surah names...');
      surahNames = {
        1: "الفَاتِحَة",
        2: "البَقَرَة",
        3: "آل عِمرَان",
        4: "النِّسَاء",
        5: "المَائِدَة",
        6: "الأَنعَام",
        7: "الأَعرَاف",
        8: "الأَنفَال",
        9: "التَّوبَة",
        10: "يُونس",
        11: "هُود",
        12: "يُوسُف",
        13: "الرَّعد",
        14: "إِبرَاهِيم",
        15: "الحِجر",
        16: "النَّحل",
        17: "الإِسرَاء",
        18: "الكَهف",
        19: "مَريَم",
        20: "طه",
        21: "الأَنبيَاء",
        22: "الحَج",
        23: "المُؤمنُون",
        24: "النُّور",
        25: "الفُرقَان",
        26: "الشُّعَرَاء",
        27: "النَّمل",
        28: "القَصَص",
        29: "العَنكَبُوت",
        30: "الرُّوم",
        31: "لُقمَان",
        32: "السَّجدَة",
        33: "الأَحزَاب",
        34: "سَبَأ",
        35: "فَاطِر",
        36: "يس",
        37: "الصَّافَّات",
        38: "ص",
        39: "الزُّمَر",
        40: "غَافِر",
        41: "فُصِّلَت",
        42: "الشُّورَى",
        43: "الزُّخرُف",
        44: "الدُّخَان",
        45: "الجَاثيَة",
        46: "الأَحقَاف",
        47: "مُحَمَّد",
        48: "الفَتح",
        49: "الحُجُرَات",
        50: "ق",
        51: "الذَّاريَات",
        52: "الطُّور",
        53: "النَّجم",
        54: "القَمَر",
        55: "الرَّحمَن",
        56: "الوَاقِعَة",
        57: "الحَديد",
        58: "المُجَادلَة",
        59: "الحَشر",
        60: "المُمتَحنَة",
        61: "الصَّف",
        62: "الجُمُعَة",
        63: "المُنَافِقُون",
        64: "التَّغَابُن",
        65: "الطَّلَاق",
        66: "التَّحرِيم",
        67: "المُلك",
        68: "القَلَم",
        69: "الحَاقَّة",
        70: "المَعَارِج",
        71: "نُوح",
        72: "الجِن",
        73: "المُزَّمِّل",
        74: "المُدَّثِّر",
        75: "القِيَامَة",
        76: "الإِنسَان",
        77: "المُرسَلَات",
        78: "النَّبَأ",
        79: "النَّازِعَات",
        80: "عَبَسَ",
        81: "التَّكوِير",
        82: "الانفِطَار",
        83: "المُطَفِّفِين",
        84: "الانشِقَاق",
        85: "البُرُوج",
        86: "الطَّارِق",
        87: "الأَعلَى",
        88: "الغَاشِيَة",
        89: "الفَجر",
        90: "البَلَد",
        91: "الشَّمس",
        92: "اللَّيل",
        93: "الضُّحَى",
        94: "الشَّرح",
        95: "التِّين",
        96: "العَلَق",
        97: "القَدر",
        98: "البَيِّنَة",
        99: "الزَّلزَلَة",
        100: "العَادِيَات",
        101: "القَارِعَة",
        102: "التَّكَاثُر",
        103: "العَصر",
        104: "الهُمَزَة",
        105: "الفِيل",
        106: "قُرَيش",
        107: "المَاعُون",
        108: "الكَوثَر",
        109: "الكَافِرُون",
        110: "النَّصر",
        111: "المَسَد",
        112: "الإِخلَاص",
        113: "الفَلَق",
        114: "النَّاس"
      };
      print('📚 Loaded ${surahNames?.length} surah names');
    } catch (e) {
      print('❌ Error loading surah names: $e');
      error.value = 'Error loading surah names: $e';
    }
  }

  String getSurahName(int surahNumber) {
    return surahNames?[surahNumber] ?? 'Surah $surahNumber';
  }

  bool isStartOfSurah(int pageNumber, QuranVerse verse) {
    // Extract surah and ayah numbers from verse.verseNumber (format: "surah:ayah")
    final parts = verse.verseNumber.split(':');
    final ayahNumber = int.parse(parts[1]);

    // If it's ayah 1, it's the start of a surah
    return ayahNumber == 1;
  }

  Future<void> loadPageToSurahMapping() async {
    try {
      print('📚 Loading page to surah mapping...');
      pageToSurahMap = await _jsonParser.parsePageToChapterJsonData();
      print('📚 Loaded mapping for ${pageToSurahMap?.length} pages');
    } catch (e) {
      print('❌ Error loading page to surah mapping: $e');
      error.value = 'Error loading page mappings: $e';
      rethrow;
    }
  }

  void updateSurahForPage(int page) {
    if (pageToSurahMap != null && pageToSurahMap!.containsKey(page)) {
      List<int> surahsInPage = pageToSurahMap![page]!;
      if (surahsInPage.isNotEmpty) {
        currentSurah.value = surahsInPage.first;
        print('📖 Updated surah to ${currentSurah.value} for page $page');
      }
    } else {
      print('⚠️ No surah mapping found for page $page');
    }
  }

  Future<void> loadNextPages() async {
    if (isLoading.value || !hasMorePages.value) return;

    try {
      print('⏳ Loading next pages starting from: ${currentPage.value}');
      isLoading.value = true;
      error.value = '';

      // Load 5 pages initially, then 3 pages for subsequent loads
      int pagesToLoad = versesByPage.isEmpty ? 5 : 3;
      print('📚 Loading $pagesToLoad pages');

      for (int i = 0; i < pagesToLoad; i++) {
        int pageToLoad = currentPage.value + i;

        if (pageToSurahMap != null &&
            !pageToSurahMap!.containsKey(pageToLoad)) {
          hasMorePages.value = false;
          break;
        }

        updateSurahForPage(pageToLoad);
        final fetchedVerses = await _quranService.fetchAyas(
          pageToLoad,
          currentSurah.value,
        );

        if (fetchedVerses.isEmpty) {
          hasMorePages.value = false;
          break;
        }

        versesByPage[pageToLoad] = fetchedVerses;
        print('📦 Loaded page $pageToLoad with ${fetchedVerses.length} verses');
      }

      currentPage.value += pagesToLoad;
    } catch (e) {
      print('❌ Error loading pages: $e');
      error.value = 'Error loading pages: $e';
    } finally {
      isLoading.value = false;
      print(
          '🏁 Page loading completed - Total pages loaded: ${versesByPage.length}');
    }
  }

  bool shouldLoadMore(int currentPageIndex) {
    return currentPageIndex >= versesByPage.length - 2 &&
        hasMorePages.value &&
        !isLoading.value;
  }
}
