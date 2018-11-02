import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:juejin_flutter/config/config_color.dart';
import 'package:juejin_flutter/model/entry.dart';

Future<List<Entry>> fetchPost() async {
  final response = await http.get(
      'https://timeline-merger-ms.juejin.im/v1/get_entry_by_rank?src=web&before=15.838909742541&limit=20&category=all');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var decode = json.decode(response.body);
    var entrylist = decode['d']['entrylist'];
    var list = List<Entry>();
    for (var value in entrylist) {
      try {
        var entry = Entry.fromJson(value);
        list.add(entry);
      } catch (e) {
        print(e);
      }
    }
    return list;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Entry> items = List<Entry>();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _onRefresh();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("loadMore");
        _getMoreData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: ConfigColor.colorPrimary,
          elevation: 1.0,
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: items.length <= 0 ? 0 : items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                return _buildProgressIndicator();
              } else {
                final item = items[index];
                return getItemView(item);
              }
            },
            controller: _scrollController,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
        margin: EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
            height: 20.0,
            width: 20.0,
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget getItemView(Entry entry) {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.only(top: 16.0, right: 16.0, bottom: 4.0),
        decoration: BoxDecoration(
          color: ConfigColor.colorContentBackground,
          boxShadow: [
            new BoxShadow(color: Color(0x18000000), blurRadius: 1.0, offset: Offset(0.0, 0.5))
          ]
        ),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(entry.user.avatarLarge),
                    backgroundColor: ConfigColor.colorWindowBackground,
                  ),
                  width: 24.0,
                  height: 24.0),
              Container(
                child: Text(
                  entry.user.username,
                  maxLines: 1,
                  style:
                      TextStyle(fontSize: 12.0, color: ConfigColor.colorText1),
                ),
                margin: EdgeInsets.only(left: 8.0),
              )
            ],
          ),
          Container(
            child: Text(
              entry.title.toUpperCase(),
              maxLines: 2,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: ConfigColor.colorText1),
            ),
            width: double.infinity,
            padding: EdgeInsets.only(top: 8.0, left: 16.0),
          ),
          Container(
            child: Text(
              entry.content.trim(),
              maxLines: 3,
              style: TextStyle(
                  fontSize: 12.0, color: ConfigColor.colorText2, height: 1.3),
            ),
            padding: EdgeInsets.only(top: 4.0, left: 16.0),
          ),
          Container(
            child: Row(children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 4.0, left: 16.0),
                    child: Image.asset("assets/timeline_like_normal.png",
                        width: 16.0, height: 16.0),
                  ),
                  Container(
                    child: Text(
                      "${entry.collectionCount}",
                      style: TextStyle(
                          fontSize: 12.0, color: ConfigColor.colorText3),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 4.0, left: 16.0),
                    child: Image.asset("assets/timeline_comment.png",
                        width: 16.0, height: 16.0),
                  ),
                  Container(
                    child: Text(
                      "${entry.commentsCount}",
                      style: TextStyle(
                          fontSize: 12.0, color: ConfigColor.colorText3),
                    ),
                  ),
                ],
              ),
            ]),
            height: 40.0,
          )
        ]));
  }

  Future<Null> _onRefresh() async {
    await fetchPost().then((list) {
      setState(() {
        items.clear();
        items.addAll(list);
        return null;
      });
    });
  }

  Future<Null> _getMoreData() async {
    await fetchPost().then((list) {
      setState(() {
        items.addAll(list);
        return null;
      });
    });
  }
}
