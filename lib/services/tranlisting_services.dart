import 'package:alquran_malayalam/models/transl.dart';
import 'package:alquran_malayalam/services/dbservice.dart';
import 'dart:developer';

class TranListingServices {
  final dbProvider = DBService.dbProvider;

  Future openDB() async {
    return await dbProvider.openDB();
  }

  Future<List<TranLine>> getTranLines(
      {required int suraNo,
      int pageNo = 1,
      int perPage = 7,
      int inStartAyaNo = 1}) async {
    final db = await dbProvider.database;
    int startAyaNo =
        inStartAyaNo > 1 ? inStartAyaNo : (pageNo - 1) * perPage + 1;
    int endAyaNo = (pageNo - 1) * perPage + perPage;

    List<Map<String, dynamic>> result;
    String searchSql = '';
    String whereStr = '';
    if (suraNo > 0) {
      searchSql = "AND tw.sura_no=$suraNo ";
      whereStr = "AND tw.aya_no BETWEEN $startAyaNo AND $endAyaNo ";
    }
    try {
      log('Executing getTranLines query for suraNo: $suraNo with Aya range: $startAyaNo-$endAyaNo');
      result = await db.rawQuery("""
          SELECT tw.line_id, tw.sura_no, tw.aya_no, 
                 GROUP_CONCAT(tw.arabwords, '|||') as arabwords,
                 GROUP_CONCAT(tw.malwords, '|||') as malwords,
                 l.malay_meaning
          FROM trans_words tw
          LEFT JOIN line l ON l.line_id = tw.line_id
          WHERE 1=1 $searchSql $whereStr 
          GROUP BY tw.line_id
          ORDER BY tw.sura_no, tw.aya_no, tw.line_id
      """);
      log('Query returned "+result.length+" rows in getTranLines');
      List<TranLine> lines = result.isNotEmpty
          ? result.map((item) => TranLine.fromMap(item)).toList()
          : [];
      if (lines.isNotEmpty) {
        int i = 0;
        for (TranLine rLine in lines) {
          if (i == 0 || (i > 0 && lines[i].ayaNo != lines[i - 1].ayaNo)) {
            rLine.malTran = '${rLine.ayaNo}. ${rLine.malTran}';
          }
          i++;
        }
      }
      return lines;
    } catch (e) {
      log('Error in getTranLines: ${e.toString()}');
      return Future.error(e);
    }
  }

  Future getSearchTranLines({required String queryString}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    String whereStr = '';

    whereStr = "AND malay_meaning LIKE '%$queryString%' ";
    try {
      log('Executing getSearchTranLines with query: $queryString');
      result = await db.rawQuery(
          "SELECT line_id, sura_no, aya_no, malay_meaning, '' AS malwords, '' AS arabwords FROM line  WHERE 1=1 $whereStr ORDER BY sura_no, aya_no, line_id ");
      log('Query returned "+result.length+" rows in getSearchTranLines');
      List<TranLine> lines = result.isNotEmpty
          ? result.map((item) => TranLine.fromMap(item)).toList()
          : [];
      if (lines.length > 0) {
        int i = 0;
        for (TranLine rLine in lines) {
          if (i == 0 || (i > 0 && lines[i].ayaNo != lines[i - 1].ayaNo)) {
            rLine.malTran = rLine.ayaNo.toString() + '. ' + rLine.malTran;
          }
          i++;
        }
      }
      return lines;
    } catch (e) {
      log('Error in getSearchTranLines: ${e.toString()}');
      return Future.error(e);
    }
  }

  Future<String?> getMalayMeaning({required int lineId}) async {
    final db = await dbProvider.database;
    try {
      final result = await db.rawQuery(
          "SELECT malay_meaning FROM line WHERE line_id = ?", [lineId]);
      if (result.isNotEmpty) {
        return result.first['malay_meaning'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      log('Error in getMalayMeaning: "+e.toString()+"');
      return Future.error(e);
    }
  }
}
