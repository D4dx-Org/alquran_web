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

  @override
  void onInit() {
    super.onInit();
    print('🚀 MushafController initialized');
    initializeController();
  }

  Future<void> initializeController() async {
    try {
      await loadPageToSurahMapping();
      print('🔄 Initial fetch started');
      updateSurahForPage(currentPage.value);
      await loadNextPages();
    } catch (e) {
      print('❌ Error initializing controller: $e');
      error.value = 'Error initializing: $e';
    }
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

      // Load next 3 pages
      for (int i = 0; i < 3; i++) {
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

      currentPage.value += 3;
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
