import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:juejin_flutter/config/config_color.dart';
import 'package:juejin_flutter/model/entry.dart';
import 'package:juejin_flutter/widget/banner/banner_evalutor.dart';
import 'package:juejin_flutter/widget/banner/banner_widget.dart';

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

class ExplorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExplorePageState();
  }
}

class _ExplorePageState extends State<ExplorePage> {
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
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.infinity,
            height: 36.0,
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(Radius.circular(3.0))),
            child: Row(children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.white,
                size: 20.0,
              ),
              Container(
                child: Text(
                  "搜索",
                  style: TextStyle(color: Colors.white30, fontSize: 14.0),
                ),
                margin: EdgeInsets.only(left: 8.0),
              )
            ]),
          ),
          backgroundColor: ConfigColor.colorPrimary,
          elevation: 1.0,
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: items.length <= 0 ? 1 : items.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildExploreHeader();
              } else if (index == items.length) {
                return _buildProgressIndicator();
              } else {
                final item = items[index - 1];
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

  Widget _buildExploreHeader() {
    final List<Model> data = [
      new Model(
          imgUrl:
              'https://img01.sogoucdn.com/app/a/100520093/60d2f4fe0275d790-007c9f9485c5acfd-bdc6566f9acf5ba2a7e7190734c38920.jpg'),
      new Model(
          imgUrl:
              'http://img4.duitang.com/uploads/item/201502/27/20150227083741_w5YjR.jpeg'),
      new Model(
          imgUrl:
              'http://img4.duitang.com/uploads/item/201501/06/20150106081248_ae4Rk.jpeg'),
      new Model(
          imgUrl: 'http://pic1.win4000.com/wallpaper/a/59322eda4daf0.jpg'),
      new Model(
          imgUrl: 'http://uploads.5068.com/allimg/1711/151-1G130093R1.jpg'),
    ];
    return BannerWidget(
      data: data,
      curve: ElasticInOutCurve(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget getItemView(Entry entry) {
    return Container(
        height: 100.0,
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0, left: 16.0),
        decoration: BoxDecoration(
            color: ConfigColor.colorContentBackground,
            boxShadow: [
              new BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 1.0,
                  offset: Offset(0.0, 0.5))
            ]),
        child: Row(children: <Widget>[
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  entry.title.toUpperCase(),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14.0,
                      height: 1.2,
                      color: ConfigColor.colorText1),
                ),
              ),
              Container(
                child: Text(
                  entry.user.username,
                  maxLines: 1,
                  style:
                      TextStyle(fontSize: 10.0, color: ConfigColor.colorText2),
                ),
                margin: EdgeInsets.only(top: 8.0),
              ),
            ],
          )),
          Container(
            height: 60.0,
            width: 60.0,
            color: Colors.black38,
            child: Image.network(entry.screenshot == null ? "http://ww1.sinaimg.cn/large/8c9b876fly1fwy7sudnjhj201f00q04c.jpg" : entry
                .screenshot,
                fit: BoxFit.cover),
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

class Model extends Object with BannerWithEval {
  final String imgUrl;

  Model({this.imgUrl});

  @override
  get bannerUrl => imgUrl;
}
