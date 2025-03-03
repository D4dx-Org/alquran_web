class Surah {
  static const db_suraid = "Sura_id";
  static const db_asuraname = "ASuraName";
  static const db_msuraname = "MSuraName";
  static const db_malmean = "MalMean";
  static const db_suratype = "SuraType";
  static const db_totalayas = "TotalAyas";
  static const db_totallines = "TotalLines";

  int suraId;
  String aSuraName;
  String mSuraName;
  String suraType;
  String malMean;
  int totalAyas;
  int totalLines;

  Surah(
      {required this.suraId,
      required this.aSuraName,
      required this.mSuraName,
      required this.suraType,
      required this.malMean,
      required this.totalAyas,
      required this.totalLines});

  factory Surah.fromMap(Map<String, dynamic> map) => Surah(
        suraId: int.parse(map[db_suraid].toString()),
        aSuraName: map[db_asuraname],
        mSuraName: map[db_msuraname],
        suraType: map[db_suratype],
        malMean: map[db_malmean],
        totalAyas: int.parse(map[db_totalayas].toString()),
        totalLines: int.parse(map[db_totallines].toString()),
      );

  // Currently not used

  Map<String, dynamic> toMap() => {
        db_suraid: suraId,
        db_asuraname: aSuraName,
        db_msuraname: mSuraName,
        db_suratype: suraType,
        db_malmean: malMean,
        db_totalayas: totalAyas,
        db_totallines: totalLines,
      };

  toString() => "Surah => " + toMap().toString();
}
