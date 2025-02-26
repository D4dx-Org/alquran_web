import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/pages/index/components/surah_item_view.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurahListing extends StatelessWidget {
  final List<Surah> surahs;
  final IndexController controller = Get.find();
  SurahListing({super.key, required this.surahs});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(5.0),
      itemCount: surahs.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return SurahItemView(
          surah: surahs[index],
          index: index,
        );
      },
    );
  }
}
