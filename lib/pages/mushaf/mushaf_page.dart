import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/pages/mushaf/mushaf_controller.dart';
import 'package:alquran_malayalam/helpers/arabic_numbers.dart';

class MushafPage extends StatefulWidget {
  const MushafPage({super.key});

  @override
  State<MushafPage> createState() => _MushafPageState();
}

class _MushafPageState extends State<MushafPage> {
  final MushafController controller = Get.find<MushafController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      controller.loadNextPages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => controller.error.value.isNotEmpty
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
                        onPressed: controller.loadNextPages,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.versesByPage.length +
                      (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.versesByPage.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final pageNumber =
                        controller.versesByPage.keys.elementAt(index);
                    final verses = controller.versesByPage[pageNumber]!;

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Wrap(
                              alignment: WrapAlignment.end,
                              spacing: 4,
                              runSpacing: 8,
                              children: verses.map((verse) {
                                return GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Verse: ${verse.verseNumber}'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '${verse.arabicText} \u06DD${ArabicNumbers.toArabicNumerals(int.parse(verse.verseNumber.split(':').last))} ',
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
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1.0,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                ArabicNumbers.toArabicNumerals(pageNumber),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'AmiriQuran',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
