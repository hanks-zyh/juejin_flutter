import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  var title;
  var items;

  ExplorePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: title,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new ListView.builder(
          // Let the ListView know how many items it needs to build
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens! We'll
          // convert each item into a Widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items[index];

          },
        ),
      ),
    );
  }
}
