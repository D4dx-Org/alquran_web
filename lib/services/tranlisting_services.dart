import 'package:alquran_malayalam/models/transl.dart';
import 'package:alquran_malayalam/services/api_service/quran_service.dart';
import 'dart:developer';

class TranListingServices {
  final QuranService _quranService = QuranService();

  Future<List<TranLine>> getTranLines(
      {required int suraNo,
      int pageNo = 1,
      int perPage = 7,
      int inStartAyaNo = 1}) async {
    try {
      print('Getting translation lines for Surah $suraNo, page $pageNo');
      final lines = await _quranService.fetchAyaLines(suraNo, pageNo);
      print('Received ${lines.length} lines from API');

      if (lines.isEmpty) {
        print('No translation lines available for Surah $suraNo, page $pageNo');
        return [];
      }

      List<TranLine> tranLines = [];
      for (var item in lines) {
        try {
          // The QuranService now ensures these are integers
          final lineId = item['LineId'] as int;
          final suraNo = item['SuraNo'] as int;
          final ayaNo = item['AyaNo'] as int;
          final malTran = item['MalTran'] as String;
          final lineWords = item['LineWords'] as List;

          tranLines.add(TranLine(
            lineId: lineId,
            suraNo: suraNo,
            ayaNo: ayaNo,
            malTran: malTran,
            arabWords:
                lineWords.map((w) => w['ArabWord'] as String).join('|||'),
            malWords: lineWords.map((w) => w['MalWord'] as String).join('|||'),
          ));
        } catch (e) {
          print('Error mapping line: $e');
          print('Problematic item: $item');
          continue;
        }
      }

      print('Successfully mapped ${tranLines.length} translation lines');
      return tranLines;
    } catch (e) {
      log('Error in getTranLines: ${e.toString()}');
      if (e.toString().contains('204')) {
        print('No content available, returning empty list');
        return [];
      }
      return Future.error(e);
    }
  }

  Future<List<TranLine>> getSearchTranLines(
      {required String queryString}) async {
    try {
      final results = await _quranService.fetchSearchResult(queryString);
      return results
          .map((item) => TranLine(
                lineId: item['LineId'],
                suraNo: item['SuraNo'],
                ayaNo: item['AyaNo'],
                malTran: item['MalTran'],
                arabWords: '',
                malWords: '',
              ))
          .toList();
    } catch (e) {
      log('Error in getSearchTranLines: ${e.toString()}');
      return Future.error(e);
    }
  }

  Future<String?> getMalayMeaning({required int lineId}) async {
    try {
      // Since we don't have a direct API endpoint for getting meaning by line ID,
      // we'll need to get the verse that contains this line and find the matching line
      final lines = await _quranService.fetchVerses(
          1, 1); // We'll need to modify this to get the correct verse
      final line = lines.firstWhere(
        (l) => l['LineId'] == lineId,
        orElse: () => throw Exception('Line not found'),
      );
      return line['MalTran'];
    } catch (e) {
      log('Error in getMalayMeaning: ${e.toString()}');
      return Future.error(e);
    }
  }
}
