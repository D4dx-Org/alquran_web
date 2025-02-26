import 'package:alquran_malayalam/pages/bookmarks/bookmarks_page.dart';
import 'package:alquran_malayalam/pages/index/components/surah_listing.dart';
import 'package:alquran_malayalam/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/widgets/drawer.dart';

class IndexPage extends StatelessWidget {
  List<Surah> surahs = [];
  final IndexController controller = Get.put(IndexController());
  IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: Color(0xFF734E09),
          foregroundColor: Color(0xFFFFFFFF),
          title: Text(
            "Al Quran Malayalam",
          ),
          elevation: 0,
          actions: [
            Obx(() => IconButton(
                  icon: (!controller.isSearching.value)
                      ? const Icon(
                          Icons.search,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                  onPressed: () {
                    if (!controller.isSearching.value) {
                      controller.isSearching.value = true;
                    } else {
                      controller.isSearching.value = false;
                    }
                  },
                )),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 80), // Space for the floating tab bar
                Expanded(
                  child: TabBarView(
                    children: [
                      // Surah Tab
                      GetBuilder<IndexController>(
                        init: controller,
                        builder: (_) => controller.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Obx(
                                    () => (!controller.isSearching.value)
                                        ? Container()
                                        : SearchWidget(),
                                  ),
                                  Expanded(
                                    child: SurahListing(
                                      surahs: controller.surahs,
                                    ),
                                  )
                                ],
                              ),
                      ),
                      // Juz Tab
                      Center(
                        child: Text(
                          'Juz View Coming Soon',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      // Bookmarks Tab
                      GetBuilder<IndexController>(
                        init: controller,
                        builder: (_) => controller.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : BookmarksPage(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildCustomTabBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        onTap: (index) {
          controller.selectedTabIndex.value = index;
        },
        tabs: [
          _buildTab(
            icon: Icons.star_border_rounded,
            label: 'Surat',
            index: 0,
          ),
          _buildTab(
            icon: Icons.menu_book_outlined,
            label: 'Juz',
            index: 1,
          ),
          _buildTab(
            icon: Icons.bookmark_border,
            label: 'Bookmarks',
            index: 2,
          ),
        ],
        indicator: BoxDecoration(),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade700,
        indicatorSize: TabBarIndicatorSize.label,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        labelPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return Obx(() {
      final isSelected = controller.selectedTabIndex.value == index;
      return Tab(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF734E09) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border:
                !isSelected ? Border.all(color: Colors.grey.shade300) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              SizedBox(width: 4),
              Text(label),
            ],
          ),
        ),
      );
    });
  }
}
