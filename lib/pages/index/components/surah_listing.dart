import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/widgets/ayah_picker.dart';

class SurahListing extends StatelessWidget {
  final List<Surah> surahs;
  final IndexController controller = Get.find();
  SurahListing({super.key, required this.surahs});

  Widget _buildSurahItemView({required Surah surah, required int index}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          controller.selectSurah(surah);
          controller.loadSuraDetailPage(surah.suraId, ayaNo: 1);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: const ExactAssetImage('assets/img/numbg.png'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    surah.suraId.toString(),
                    style: const TextStyle(
                      fontFamily: 'NotoSansMalayalam',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF303030),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                  ],
                ),
              ),
              Text(
                surah.aSuraName.replaceAll(' سورة ', ' '),
                style: const TextStyle(
                  fontFamily: 'AmiriQuran',
                  fontSize: 20,
                  color: Color(0xFF734E09),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.low_priority),
                color: const Color(0xFF734E09),
                onPressed: () {
                  AyahPickerDialog ayahPickerDialog = AyahPickerDialog(
                    onOkPressed: () async {
                      Get.back();
                      controller.loadSuraDetailPage(surah.suraId,
                          ayaNo: controller.selAyahNo.value);
                    },
                    cSurah: surah,
                  );
                  ayahPickerDialog.showAyaNoDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(5.0),
      itemCount: surahs.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return _buildSurahItemView(surah: surahs[index], index: index);
      },
    );
  }
}
