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

class _ExplorePageState extends State<ExplorePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

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
            itemCount: items.length <= 0 ? 0 : items.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildExploreHeader();
              } else if (index == items.length + 1) {
                return _buildProgressIndicator();
              } else {
                var i = index - 1;
                if(i>=0 && i < items.length){
                  final item = items[i];
                  return getItemView(item);
                }else{
                  return _buildProgressIndicator();
                }
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
              'https://user-gold-cdn.xitu.io/2018/11/8/166f3b31f23e06b5?imageView2/1/w/1304/h/734/q/85/format/webp/interlace/1'),
      new Model(
          imgUrl:
              'https://user-gold-cdn.xitu.io/2018/11/6/166e6521376a2858?imageView2/1/w/1304/h/734/q/85/format/webp/interlace/1'),
      new Model(
          imgUrl: 'https://user-gold-cdn.xitu.io/2018/11/7/166ee89218c82bc4?imageView2/1/w/1304/h/734/q/85/format/webp/interlace/1'),
        ];
    return Column(
      children: <Widget>[
        BannerWidget(
          height: 160,
          data: data,
          curve: Curves.decelerate,
          duration: 520,
        ),
        Container(
          height: 84.0,
          color: ConfigColor.colorContentBackground,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton(
                      onPressed: () => {},
                      padding: EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.whatshot,
                            color: Color(0xFFFF5E35),
                            size: 36.0,
                          ),
                          Text(
                            "本周最热",
                            style: TextStyle(
                              color: ConfigColor.colorText1,
                              fontSize: 12.0,
                            ),
                          )
                        ],
                      ))),
              Expanded(
                  child: FlatButton(
                      padding: EdgeInsets.only(top: 16.0),
                      onPressed: () => {},
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.confirmation_number,
                              color: Color(0xFF18C09A), size: 36.0),
                          Text(
                            "收藏集合",
                            style: TextStyle(
                                color: ConfigColor.colorText1, fontSize: 12.0),
                          )
                        ],
                      ))),
              Expanded(
                  child: FlatButton(
                      padding: EdgeInsets.only(top: 16.0),
                      onPressed: () => {},
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.notifications,
                              color: Color(0xFFFFCC00), size: 36.0),
                          Text(
                            "活动",
                            style: TextStyle(
                                color: ConfigColor.colorText1, fontSize: 12.0),
                          )
                        ],
                      ))),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.only(left: 16.0, right: 8.0),
          height: 40.0,
          color: ConfigColor.colorContentBackground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.whatshot,
                  color: Color(0xFFFF5E35),
                  size: 16.0,
                ),
                margin: EdgeInsets.only(right: 8.0),
              ),
              Expanded(
                  child: Text(
                "本周最热",
                style: TextStyle(
                  color: ConfigColor.colorText1,
                  fontSize: 13.0,
                ),
              )),
              Row(
                children: <Widget>[
                  Icon(Icons.settings, color: Colors.black26, size: 16.0),
                  Container(
                    child: Text(
                      "定制热门",
                      style: TextStyle(
                          color: ConfigColor.colorText2, fontSize: 12.0),
                    ),
                    margin: EdgeInsets.only(left: 4.0, right: 8.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget getItemView(Entry entry) {
    return Container(
        padding:
            EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0, left: 16.0),
        decoration: BoxDecoration(
          color: ConfigColor.colorContentBackground,
          border: Border(
              top: BorderSide(color: ConfigColor.colorDivider, width: 0.5)),
        ),
        child: Row(children: <Widget>[
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  entry.title.toUpperCase(),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14.0,
                      height: 1.1,
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
          getScreenshotWidget(entry.screenshot)
        ]));
  }

  Widget getScreenshotWidget(String url){
    if(url == null || url.isEmpty) return Container();
    return Container(
      height: 60.0,
      width: 60.0,
      child: Image.network(url, fit: BoxFit.cover),
    );
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
