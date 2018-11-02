import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:juejin_flutter/config/config_color.dart';
import 'package:juejin_flutter/page/logoPage.dart';

void main(){
//  debugPaintSizeEnabled = true;
  runApp(MaterialApp(
    theme: ConfigColor.themeData,
    home: LogoPage(),
  ));

}
