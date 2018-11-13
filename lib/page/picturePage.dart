import 'package:flutter/material.dart';

class PicturePage extends StatefulWidget {
  final String url;

  PicturePage({Key key, @required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PictureState(url);
  }
}

class _PictureState extends State<PicturePage> {
  String url;

  _PictureState(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Hero(
          tag: "img",
          child: Image.network(
            url,
            fit: BoxFit.contain,
          )),
    );
  }
}
