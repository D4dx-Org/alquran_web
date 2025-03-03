import 'package:alquran_malayalam/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/models/transl.dart';
import 'package:alquran_malayalam/pages/searchres/searchres_controller.dart';
import 'package:alquran_malayalam/routes/routes.dart';

class SearchResPage extends StatelessWidget {
  final SearchResController controller = Get.put(SearchResController());

  SearchResPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF734E09),
        foregroundColor: Color(0xFFFFFFFF),
        title: Text("Search"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.toNamed(AppRoutes.BOOKMARKS, preventDuplicates: true);
            }
          )
        ],
      ),
      body: GetBuilder<SearchResController>(
        init: controller,
        builder: (_) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  SearchWidget(),
                ],
              ),
            );
          }

          return SearchResListing(
            tranLineList: controller.tranLineList,
          );
        },
      ),
    );
  }
}

class SearchResListing extends StatelessWidget {
  final List<TranLine> tranLineList;
  final SearchResController controller = Get.find();

  SearchResListing({Key? key, required this.tranLineList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchWidget(),
        if (tranLineList.isEmpty) Expanded(
          child: Center(
            child: Text(
              'No results found.\nTry a different search term.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ) else ...[
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                'Search Results (${tranLineList.length}):',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(48, 48, 48, 1),
                  fontFamily: 'Lato',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: tranLineList.length * 2 - 1,
              separatorBuilder: (context, index) => Divider(
                height: 10.0,
                color: const Color(0xFF240F4F),
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index % 2 != 0) {
                  return SizedBox.shrink();
                }
                int j = index ~/ 2;
                TranLine cTranLine = tranLineList[j];
                return ListTile(
                  title: _viewTranLinewidget(cTranLine, j),
                  trailing: IconButton(
                    icon: const Icon(Icons.link),
                    color: Color(0xFF734E09),
                    onPressed: () => controller.showSuraTranLines(
                      cTranLine.suraNo,
                      cTranLine.ayaNo,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _viewTranLinewidget(TranLine inTranLine, int index) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      alignment: Alignment.topLeft,
      child: GestureDetector(
        child: Text(
          '${inTranLine.suraNo}: ${inTranLine.malTran}',
          style: TextStyle(
            fontFamily: 'NotoSansMalayalam',
            fontSize: controller.fontSizeMalayalam.value,
            color: const Color(0xFF240F4F),
          ),
          textAlign: TextAlign.left,
        ),
        onTap: () => controller.showSuraTranLines(
          inTranLine.suraNo,
          inTranLine.ayaNo,
        ),
      ),
    );
  }
}
