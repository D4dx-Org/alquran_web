import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:alquran_malayalam/models/juz.dart';

class JsonParser {
  Future<Map<String, dynamic>> loadJsonData() async {
    final jsonString = await rootBundle
        .loadString("assets/json/juz-to-chapter-verse-mappings.json");
    return json.decode(jsonString);
  }

  Future<List<Juz>> loadJuzData() async {
    final Map<String, dynamic> jsonData = await loadJsonData();
    List<Juz> juzList = [];

    jsonData.forEach((key, value) {
      juzList.add(Juz.fromMap(int.parse(key), value));
    });

    return juzList;
  }
}
