import 'package:alquran_malayalam/pages/bookmarks/bookmarks_page.dart';
import 'package:alquran_malayalam/pages/index/components/surah_listing.dart';
import 'package:alquran_malayalam/pages/index/components/juz_listing.dart';
import 'package:alquran_malayalam/routes/routes.dart';
import 'package:alquran_malayalam/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/widgets/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class IndexPage extends StatelessWidget {
  List<Surah> surahs = [];
  final IndexController controller = Get.find<IndexController>();
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
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.MUSHAF);
                },
                child: Text(
                  "അല്‍ ഖുര്‍ആന്‍",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'NotoSansMalayalam',
                  ),
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
            TextButton.icon(
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ),
              label: const Text(
                'Old Site',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              style: TextButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final Uri url = Uri.parse('https://old.alquranmalayalam.net');
                try {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                } catch (e) {
                  print('Error launching URL: $e');
                }
              },
            ),
            SizedBox(width: 20),
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
                      GetBuilder<IndexController>(
                        builder: (_) => controller.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : JuzListing(
                                juzList: controller.juzList,
                              ),
                      ),
                      // Bookmarks Tab
                      GetBuilder<IndexController>(
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
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
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
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF734E09), Color(0xFFB57B3E)],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        unselectedLabelColor: Colors.black,
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        padding: EdgeInsets.all(4),
        labelPadding: EdgeInsets.symmetric(horizontal: 2),
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
  }
}
