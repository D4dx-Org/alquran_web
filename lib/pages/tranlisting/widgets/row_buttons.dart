import 'package:alquran_malayalam/pages/tranlisting/tranlisting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';
import 'package:alquran_malayalam/models/transl.dart';

class RowButtonsRow extends StatelessWidget {
  final TranListingController controller = Get.find();
  final TranLine curTranLine;

  RowButtonsRow(this.curTranLine, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 4),
        width: 327,
        height: 47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Color.fromARGB(255, 240, 216, 172),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10),
                Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    child: Text(
                      '${curTranLine.suraNo}:${curTranLine.ayaNo}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF734E09),
                        fontFamily: 'NotoSansMalayalam',
                        fontSize: 15,
                      ),
                    )),
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    shareBtn(curTranLine),
                    bookmarkBtn(curTranLine),
                  ],
                ))
          ],
        ));
  }

  Widget shareBtn(TranLine curTranLine) {
    return Transform.scale(
        scale: 0.90,
        child: IconButton(
          onPressed: () async {
            String suraNameNo =
                '${curTranLine.suraNo}:${curTranLine.ayaNo} - Ayah part ';
            String siteLink = "https://alquranmalayalam.net";
            await Share.share(
                "$suraNameNo\n\n${curTranLine.arabWords.replaceAll('#', ' ')}\n\n${curTranLine.malTran}\n\n$siteLink",
                subject: "Share Ayah Line");
          },
          icon: const Icon(Icons.share_outlined,
              color: Color(0xFF734E09), size: 26),
        ));
  }

  Widget bookmarkBtn(TranLine curTranLine) {
    return Transform.scale(
        scale: 0.90,
        child: IconButton(
          onPressed: () async {
            controller.bookmarkAyahLine(curTranLine);
          },
          icon: const Icon(Icons.bookmark_outline,
              color: Color(0xFF734E09), size: 28),
        ));
  }
}
