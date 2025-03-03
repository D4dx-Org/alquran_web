import 'package:alquran_malayalam/routes/routes.dart';
import 'package:alquran_malayalam/widgets/ayah_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Color(0xFF734E09),
        foregroundColor: Color(0xFFFFFFFF),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "അല്‍ ഖുര്‍ആന്‍",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'NotoSansMalayalam',
              ),
            ),
            Text(
              "വാക്കര്‍ത്ഥത്തോടുകൂടിയ പരിഭാഷ",
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'NotoSansMalayalam',
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.SETTINGS);
              },
              icon: Icon(Icons.settings)),
        ],
      ),
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
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: RichText(
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              children: verses.map(
                                (verse) {
                                  return TextSpan(
                                    text:
                                        '${verse.arabicText} \u06DD${ArabicNumbers.toArabicNumerals(int.parse(verse.verseNumber.split(':').last))} ',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      height: 2,
                                      fontFamily: 'AmiriQuran',
                                      color: Colors.black,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Verse ${verse.verseNumber} - Page $pageNumber',
                                              textAlign: TextAlign.center,
                                            ),
                                            duration:
                                                const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                  );
                                },
                              ).toList(),
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
