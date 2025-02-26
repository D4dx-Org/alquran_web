import 'package:alquran_malayalam/models/juz.dart';
import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:alquran_malayalam/widgets/ayah_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JuzListing extends StatelessWidget {
  final List<Juz> juzList;
  final IndexController controller = Get.find();

  JuzListing({super.key, required this.juzList});

  @override
  Widget build(BuildContext context) {
    if (juzList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: juzList.length,
      itemBuilder: (context, index) {
        final juz = juzList[index];
        return _buildJuzCard(context, juz);
      },
    );
  }

  Widget _buildJuzCard(BuildContext context, Juz juz) {
    final List<Surah> surahsInJuz = controller.getSurahsForJuz(juz.juzNumber);

    if (surahsInJuz.isEmpty) {
      return Container(); // Skip if no surahs found
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(211, 211, 211, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJuzHeader(juz.juzNumber),
          ...surahsInJuz.map((surah) => _buildSurahItem(juz, surah)).toList(),
        ],
      ),
    );
  }

  Widget _buildJuzHeader(int juzNumber) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Juz $juzNumber',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF734E09),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Get the first surah in this juz
              final List<Surah> surahsInJuz =
                  controller.getSurahsForJuz(juzNumber);
              if (surahsInJuz.isNotEmpty) {
                final firstSurah = surahsInJuz.first;
                final verseRange = juzList
                    .firstWhere((j) => j.juzNumber == juzNumber)
                    .chapters[firstSurah.suraId];

                // Extract the starting verse number
                final startVerse = int.parse(verseRange!.split('-')[0]);

                // Navigate to the surah detail page
                controller.selectSurah(firstSurah);
                controller.loadSuraDetailPage(firstSurah.suraId,
                    ayaNo: startVerse);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF734E09),
              foregroundColor: Colors.white,
              minimumSize: const Size(100, 36),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Read Juz'),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahItem(Juz juz, Surah surah) {
    final verseRange = juz.chapters[surah.suraId];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Extract starting verse number from the range
          final startVerse = int.parse(verseRange!.split('-')[0]);
          controller.selectSurah(surah);
          controller.loadSuraDetailPage(surah.suraId, ayaNo: startVerse);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Surah number circle
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        const ExactAssetImage('assets/img/numbg.png'),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        surah.suraId.toString(),
                        style: const TextStyle(
                            fontFamily: 'NotoSansMalayalam',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF303030)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Surah details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.mSuraName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Image(
                          image: (surah.suraType == 'مَكِّيَة')
                              ? const ExactAssetImage('assets/img/macca.png')
                              : const ExactAssetImage('assets/img/madina.png'),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${surah.totalAyas} Ayat',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Verses: $verseRange',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Arabic name
              Text(
                surah.aSuraName.replaceAll(' سورة ', ' '),
                style: const TextStyle(
                  fontFamily: 'AmiriQuran',
                  fontSize: 20,
                  color: Color(0xFF734E09),
                ),
              ),
              // Scroll to icon
              IconButton(
                icon: const Icon(Icons.low_priority),
                color: const Color(0xFF734E09),
                onPressed: () {
                  // Get the verse range for this surah in this juz
                  final verseRange = juz.chapters[surah.suraId];
                  if (verseRange != null) {
                    // Set the selected surah
                    controller.selectSurah(surah);

                    // Show the ayah picker dialog
                    AyahPickerDialog ayahPickerDialog = AyahPickerDialog(
                      onOkPressed: () async {
                        Get.back();
                        // The NumberPicker will already constrain the value within the min-max range
                        controller.loadSuraDetailPage(surah.suraId,
                            ayaNo: controller.selAyahNo.value);
                      },
                      cSurah: surah,
                    );
                    ayahPickerDialog.showAyaNoDialog();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
