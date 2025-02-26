import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class InfoPage extends StatelessWidget {
  Color headColor = const Color(0xFF734E09);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          backgroundColor: headColor,
          title: Text("Contact", style: TextStyle(color: Colors.white)),
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Info(),
            ],
          ),
        ));
  }
}

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.decelerate);
    animation = Tween(begin: 0.0, end: 1.0).animate(curve);

    super.initState();

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Scrollbar(
          child: Container(
        height: 500,
        margin: EdgeInsets.only(left: 50.0, top: 40.0, right: 50.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            HtmlWidget(
                "<p><strong>Meem Publications,</strong><br>M.S.S Building, Cherootty Road,<br>Kozhikkode.<br><br><br><strong>Contact Address:</strong><br>V.M. ABDUL MUJEEB<br>Pookkillath<br>P.O. Farook College,<br>Kozhikkode - 673632,<br>Kerala State, India.<br><br><br><strong>Email:</strong><br>vmamujeeb@reddifmail.com<br>vmamujeeb1@gmail.com<br><br><strong>Phone:+91 9847528856</strong></p><br>"),
          ],
        ),
      )),
    );
  }
}
