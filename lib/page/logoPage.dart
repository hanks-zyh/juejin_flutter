import 'package:flutter/material.dart';
import 'package:juejin_flutter/page/mainPage.dart';

class LogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = 640;
    var app = Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Column(children: <Widget>[
        Image.asset(
          "assets/splash_bg.webp",
          height: height * 0.79,
          fit: BoxFit.cover,
        ),
        Image.asset(
          "assets/splash_logo.png",
          height: height * 0.21,
          fit: BoxFit.cover,
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
