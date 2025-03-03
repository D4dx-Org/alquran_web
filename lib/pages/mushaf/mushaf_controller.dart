import 'package:get/get.dart';
import 'package:alquran_malayalam/services/api_service/quran_com_service.dart';
import 'package:alquran_malayalam/models/verse_model.dart';
import 'package:alquran_malayalam/helpers/json_helper.dart';

class MushafController extends GetxController {
  final QuranComService _quranService = QuranComService();
  final JsonParser _jsonParser = JsonParser();

  RxList<QuranVerse> verses = <QuranVerse>[].obs;
  RxInt currentPage = 1.obs;
  RxInt currentSurah = 1.obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

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
      ever(currentPage, (page) {
        print('📄 Page changed to: $page');
        updateSurahForPage(page as int);
        fetchVerses();
      });
      print('🔄 Initial fetch started');
      updateSurahForPage(currentPage.value);
      await fetchVerses();
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

  Future<void> fetchVerses() async {
    try {
      print(
          '⏳ Starting to fetch verses - Page: ${currentPage.value}, Surah: ${currentSurah.value}');
      isLoading.value = true;
      error.value = '';

      final fetchedVerses = await _quranService.fetchAyas(
        currentPage.value,
        currentSurah.value,
      );

      print('📦 Fetched verses count: ${fetchedVerses.length}');
      print(
          '🔍 First verse: ${fetchedVerses.isNotEmpty ? fetchedVerses.first.verseNumber : "none"}');

      if (fetchedVerses.isEmpty) {
        print('⚠️ No verses found for this page');
        error.value = 'No verses found for this page';
        return;
      }

      verses.value = fetchedVerses;
      print('✅ Verses updated successfully');
    } catch (e) {
      print('❌ Error fetching verses: $e');
      error.value = 'Error loading verses: $e';
    } finally {
      isLoading.value = false;
      print(
          '🏁 Fetch operation completed - Loading: ${isLoading.value}, Error: ${error.value}');
    }
  }

  void nextPage() {
    print('➡️ Next page requested: ${currentPage.value + 1}');
    currentPage.value++;
  }

  void previousPage() {
    if (currentPage.value > 1) {
      print('⬅️ Previous page requested: ${currentPage.value - 1}');
      currentPage.value--;
    } else {
      print('⚠️ Cannot go to previous page: already at page 1');
    }
  }
}
