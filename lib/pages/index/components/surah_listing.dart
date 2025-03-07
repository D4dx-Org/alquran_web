import 'package:alquran_malayalam/constants/image_class.dart';
import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/widgets/ayah_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
                backgroundImage: const ExactAssetImage(ImageClass.numberBg),
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
                              ? const ExactAssetImage(ImageClass.macca)
                              : const ExactAssetImage(ImageClass.madina),
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

  int _getColumnCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1024) {
      // Laptop screen
      return 3;
    } else if (screenWidth >= 768) {
      // Tablet screen
      return 2;
    } else {
      // Mobile screen
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.all(5.0),
      crossAxisCount: _getColumnCount(context),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: surahs.length,
      itemBuilder: (context, index) {
        return _buildSurahItemView(surah: surahs[index], index: index);
      },
    );
  }
}
