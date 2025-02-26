class Juz {
  final int juzNumber;
  final Map<int, String> chapters; // Map of chapter number to verse range

  Juz({
    required this.juzNumber,
    required this.chapters,
  });

  factory Juz.fromMap(int juzNumber, Map<String, dynamic> map) {
    Map<int, String> chapters = {};
    map.forEach((key, value) {
      chapters[int.parse(key)] = value;
    });

    return Juz(
      juzNumber: juzNumber,
      chapters: chapters,
    );
  }
}
