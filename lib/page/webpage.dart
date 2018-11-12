import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:juejin_flutter/config/config_color.dart';

class WebPage extends StatefulWidget {
  final String url;

  WebPage({Key key, @required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebPageState(url);
  }
}

class _WebPageState extends State<WebPage> {
  String url;

  _WebPageState(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebviewScaffold(
        url: url,
        appBar: new AppBar(
          backgroundColor: ConfigColor.colorPrimary,
          elevation: 2.0,
          title: new Text("Widget webview"),
        ),
      ),
    );
  }
}
