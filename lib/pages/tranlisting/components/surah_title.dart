import 'package:alquran_malayalam/models/surah.dart';
import 'package:alquran_malayalam/pages/index/index_controller.dart';
import 'package:alquran_malayalam/pages/tranlisting/components/surah_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuraTitleWidget extends StatelessWidget {
  final IndexController suraSelController = Get.find();
  final Surah curSura = Get.find<IndexController>().selectedSurah.value!;

  SuraTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        width: 327,
        height: 247,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF734E09),
              Color(0xFFC1830F),
            ],
          ),
          image: DecorationImage(
              alignment: Alignment.bottomRight,
              colorFilter: ColorFilter.mode(
                  Color(0xFF21DAFF).withOpacity(0.02), BlendMode.softLight),
              opacity: 0.3,
              image: const ExactAssetImage('assets/img/quran.png')),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 16),
                  SuraNavWidget(),
                  SizedBox(height: 10),
                  Text(
                    curSura.aSuraName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontSize: 26.0,
                        height: 2.0,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '( ${curSura.malMean} )',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'NotoSansMalayalam',
                      fontSize: 16.0,
                      height: 2.0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(
              color: Color(0xFFFFFFFF),
              thickness: 1,
              indent: 64,
              endIndent: 64,
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    (curSura.suraType == 'مَكِّيَة') ? 'MECCAN' : 'MEDINAN',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'NotoSansMalayalam',
                        fontSize: 16,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                  SizedBox(width: 5),
                  Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color:
                            Color.fromRGBO(255, 255, 255, 0.3499999940395355),
                        borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
                      )),
                  SizedBox(width: 5),
                  Text(
                    '${curSura.totalAyas} VERSES',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'NotoSansMalayalam',
                        fontSize: 16,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ]);
  }

}
