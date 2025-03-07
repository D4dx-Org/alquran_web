// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranService {
  final String baseUrl = "https://old.alquranmalayalam.net/alquran-api";
  var ArticleId = 1;
  var surahNumber = 1;
  var AyaNumber = 1;
  var pageNumber = 0;
  String searchword = '';

  Future<List<Map<String, dynamic>>> fetchSurahs() async {
    final response = await http.get(Uri.parse("$baseUrl/suranames"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data
          .map(
            (item) => {
              "SuraId": item["SuraId"].toString(),
              "ASuraName": item["ASuraName"].toString(),
              "MSuraName": item["MSuraName"].toString(),
              "SuraType": item["SuraType"].toString(),
              "MalMean": item["MalMean"].toString(),
              "TotalAyas": item["TotalAyas"].toString(),
              "TotalLines": item["TotalLines"].toString(),
            },
          )
          .toList();
    } else {
      throw Exception('Failed to load Surahs');
    }
  }

  Future<List<String>> fetchAbout() async {
    final response = await http.get(Uri.parse("$baseUrl/articles/$ArticleId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => item['matter'] as String).toList();
    } else {
      throw Exception('Failed to load Articles');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAyaLines(
      int suraNo, int pageNo) async {
    try {
      print('Fetching aya lines for Surah $suraNo, page $pageNo');
      final response =
          await http.get(Uri.parse("$baseUrl/ayalines/$suraNo/$pageNo"));

      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        List<Map<String, dynamic>> lines = [];

        for (var item in data) {
          lines.add({
            "LineId": int.parse(item["LineId"].toString()),
            "SuraNo": int.parse(item["SuraNo"].toString()),
            "AyaNo": int.parse(item["AyaNo"].toString()),
            "MalTran": item["MalTran"].toString(),
            "LineWords": (item["LineWords"] as List).map((wordItem) {
              return {
                "MalWord": wordItem["MalWord"].toString(),
                "ArabWord": wordItem["ArabWord"].toString(),
              };
            }).toList(),
          });
        }
        print('Successfully processed ${lines.length} lines');
        return lines;
      } else if (response.statusCode == 204) {
        print('No content available for Surah $suraNo, page $pageNo');
        return [];
      } else {
        print('Failed to fetch aya lines: ${response.statusCode}');
        throw Exception(
            'Failed to load Aya lines: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching aya lines: $e');
      throw Exception('Failed to load Aya lines: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSearchResult(
      String searchword) async {
    try {
      print('Searching for: $searchword');
      final response =
          await http.get(Uri.parse("$baseUrl/searchword/0/$searchword"));
      print('Search response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        print('Found ${data.length} search results');

        // Fetch all surahs to get the MSuraName
        List<Map<String, dynamic>> surahs = await fetchSurahs();

        return data.map((item) {
          // Find the corresponding surah
          Map<String, dynamic> surah = {'MSuraName': 'Unknown'};
          try {
            surah = surahs.firstWhere(
              (s) => s['SuraId'] == item['SuraNo'].toString(),
            );
          } catch (e) {
            print('Warning: Surah not found for SuraNo: ${item['SuraNo']}');
          }

          return {
            "LineId": item["LineId"].toString(),
            "SuraNo": item["SuraNo"].toString(),
            "MSuraName": surah['MSuraName'],
            "AyaNo": item["AyaNo"].toString(),
            "MalTran": item["MalTran"].toString(),
            "LineWords": item["LineWords"] ?? [],
          };
        }).toList();
      } else {
        print('Search failed with status code: ${response.statusCode}');
        throw Exception(
            'Failed to load Search Results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchSearchResult: $e');
      throw Exception('Failed to load Search Results: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchVerses(
      int surahNumber, int verseNumber) async {
    final response = await http
        .get(Uri.parse("$baseUrl/ayalines/$surahNumber/$verseNumber"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) {
        return {
          "LineId": item["LineId"],
          "SuraNo": item["SuraNo"],
          "AyaNo": item["AyaNo"],
          "MalTran": item["MalTran"],
          "LineWords": (item["LineWords"] as List<dynamic>).map((wordItem) {
            return {
              "MalWord": wordItem["MalWord"],
              "ArabWord": wordItem["ArabWord"],
            };
          }).toList(),
        };
      }).toList();
    } else {
      throw Exception('Failed to load verse');
    }
  }

  Future<List<Map<String, dynamic>>> fetchJuz(int juzNumber) async {
    final response =
        await http.get(Uri.parse("$baseUrl/juzsuraaya/$juzNumber"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data
          .map(
            (item) => {
              "SuraId": item["SuraId"],
              "ayafrom": item["ayafrom"],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to load Juz');
    }
  }
}
