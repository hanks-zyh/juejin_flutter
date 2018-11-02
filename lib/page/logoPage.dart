import 'package:flutter/material.dart';
import 'package:juejin_flutter/page/mainPage.dart';

class LogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var app = Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Column(children: <Widget>[
        Expanded(child: Image.asset(
          "assets/splash_bg.webp",
          fit: BoxFit.cover,
        ),flex: 1,),
        Container(
          child:  Image.asset(
            "assets/splash_logo.png",
            fit: BoxFit.cover,
          ),
          height: 130.68,
        ),
      ]),
    );
    startMain(context);
    return app;
  }

  void startMain(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }
}
