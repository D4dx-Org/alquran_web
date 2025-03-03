import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/services/api_service/quran_service.dart';

class SurahServices {
  final QuranService _quranService = QuranService();

  //Get All Surah Names
  //Searches if query string was passed
  Future<List<Surah>> getSurahs({String searchKey = ''}) async {
    try {
      print('Fetching surahs from API...');
      final surahs = await _quranService.fetchSurahs();
      print('Successfully fetched ${surahs.length} surahs from API');

      List<Surah> mappedSurahs = [];

      for (var item in surahs) {
        try {
          mappedSurahs.add(Surah(
            suraId: int.parse(item['SuraId'].toString()),
            aSuraName: item['ASuraName'].toString(),
            mSuraName: item['MSuraName'].toString(),
            suraType: item['SuraType'].toString(),
            malMean: item['MalMean'].toString(),
            totalAyas: int.parse(item['TotalAyas'].toString()),
            totalLines: int.parse(item['TotalLines'].toString()),
          ));
        } catch (e) {
          print('Error mapping surah data: $e');
          print('Problematic item: $item');
          rethrow;
        }
      }

      print('Successfully mapped ${mappedSurahs.length} surahs');

      if (searchKey.isEmpty) {
        return mappedSurahs;
      }

      // Filter surahs based on search key
      return mappedSurahs
          .where((surah) =>
              surah.aSuraName.toLowerCase().contains(searchKey.toLowerCase()) ||
              surah.mSuraName.toLowerCase().contains(searchKey.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error in getSurahs: $e');
      return Future.error(e);
    }
  }

  Future<Surah?> getSurah(int id) async {
    try {
      final surahs = await _quranService.fetchSurahs();
      final surah = surahs.firstWhere(
        (s) => int.parse(s['SuraId'].toString()) == id,
        orElse: () => throw Exception('Surah not found'),
      );

      return Surah(
        suraId: int.parse(surah['SuraId'].toString()),
        aSuraName: surah['ASuraName'].toString(),
        mSuraName: surah['MSuraName'].toString(),
        suraType: surah['SuraType'].toString(),
        malMean: surah['MalMean'].toString(),
        totalAyas: int.parse(surah['TotalAyas'].toString()),
        totalLines: int.parse(surah['TotalLines'].toString()),
      );
    } catch (e) {
      print('Error in getSurah: $e');
      return Future.error(e);
    }
  }
}
