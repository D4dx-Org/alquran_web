import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/pages/mushaf/mushaf_controller.dart';

class MushafPage extends StatefulWidget {
  const MushafPage({super.key});

  @override
  State<MushafPage> createState() => _MushafPageState();
}

class _MushafPageState extends State<MushafPage> {
  final MushafController controller = Get.find<MushafController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.error.value.isNotEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.error.value,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: controller.fetchVerses,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                spacing: 4,
                                runSpacing: 8,
                                children: controller.verses.map((verse) {
                                  return GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Verse: ${verse.verseNumber}'),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '${verse.arabicText} \u06DD${verse.verseNumber.split(':').last} ',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        height: 2,
                                        fontFamily: 'AmiriQuran',
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: controller.currentPage.value > 1
                          ? () => controller.previousPage()
                          : null,
                    ),
                    Text(
                      'Page ${controller.currentPage.value}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: !controller.isLoading.value
                          ? () => controller.nextPage()
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
