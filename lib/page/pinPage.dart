import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:juejin_flutter/config/config_color.dart';
import 'package:juejin_flutter/model/entry.dart';
import 'package:juejin_flutter/model/pin.dart';
import 'package:juejin_flutter/widget/banner/banner_evalutor.dart';
import 'package:juejin_flutter/widget/banner/banner_widget.dart';

class PinPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PinPageState();
  }
}

class _PinPageState extends State<PinPage> {
  List<Pin> items = List<Pin>();
  ScrollController _scrollController = ScrollController();
  var before = "";

  Future<List<Pin>> fetchPost() async {
    final response = await http.get(
        'https://short-msg-ms.juejin.im/v1/pinList/recommend?uid=&before=${before}&limit=20&device_id=asdasd&token=&src=android');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decode = json.decode(response.body);
      var entrylist = decode['d']['list'];
      var list = List<Pin>();
      for (var value in entrylist) {
        try {
          var bean = Pin.fromJson(value);
          list.add(bean);
        } catch (e) {
          print(e);
        }
      }
      before = list.last.createdAt;
      return list;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

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
                if (i >= 0 && i < items.length) {
                  final item = items[i];
                  return getItemView(item);
                } else {
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
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget getItemView(Pin pin) {
    return Container(
        padding:
            EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0, left: 16.0),
        decoration: BoxDecoration(
          color: ConfigColor.colorContentBackground,
          border: Border(
              top: BorderSide(color: ConfigColor.colorDivider, width: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 38.0,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 0.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(pin.user.avatarLarge),
                        backgroundColor: ConfigColor.colorWindowBackground,
                      ),
                      width: 24.0,
                      height: 24.0),
                  Container(
                    margin: EdgeInsets.only(left: 8.0),
                    child: Text(
                      pin.user.username,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12.0, color: ConfigColor.colorText2),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                pin.content,
                style: TextStyle(
                    fontSize: 14.0, color: ConfigColor.colorText1, height: 1.2),
              ),
              width: double.infinity,
            ),
            getPicturesWidget(pin),
            getTopicWidget(pin),
            getBottomWidget(pin),
          ],
        ));
  }

  Widget getBottomWidget(Pin pin) {
    var likeText = pin.likedCount <= 0 ? "赞" : "${pin.likedCount}";
    var commentText = pin.commentCount <= 0 ? "评论" : "${pin.commentCount}";
    return Container(
      height: 40.0,
      child: Row(
        children: <Widget>[
          Container(
            width: 64.0,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.thumb_up,
                  size: 16.0,
                  color: ConfigColor.colorText3,
                ),
                Container(
                  margin: EdgeInsets.only(left: 4.0),
                  child: Text(likeText,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: ConfigColor.colorText3)),
                ),
              ],
            ),
          ),
          Container(
            width: 64.0,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.comment,
                  size: 16.0,
                  color: ConfigColor.colorText3,
                ),
                Container(
                  margin: EdgeInsets.only(left: 4.0),
                  child: Text(commentText,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: ConfigColor.colorText3)),
                ),
              ],
            ),
          ),
          Container(
            width: 64.0,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.share,
                  size: 16.0,
                  color: ConfigColor.colorText3,
                ),
                Container(
                  margin: EdgeInsets.only(left: 4.0),
                  child: Text("分享",
                      style: TextStyle(
                          fontSize: 12.0,
                          color: ConfigColor.colorText3)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget getScreenshotWidget(String url) {
    if (url == null || url.isEmpty) return Container();
    return Container(
      height: 60.0,
      width: 60.0,
      child: Image.network(url, fit: BoxFit.cover),
    );
  }

  Future<Null> _onRefresh() async {
    before = "";
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

  Widget getPicturesWidget(Pin pin) {
    if (pin.pictures == null || pin.pictures.length <= 0) return Container();
    var pictures = pin.pictures;
    if (pictures.length == 1) {
      return Container(
        margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Image.network(
          pictures[0],
          fit: BoxFit.cover,
        ),
        width: 200.0,
        height: 200.0,
      );
    }
    var imageRow = List<Widget>();
    for (var value in pictures) {
      imageRow.add(Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
          height: 80.0,
          child: Image.network(
            value,
            fit: BoxFit.cover,
          ),
        ),
      ));
    }
    return Row(
      children: imageRow,
    );
  }

  Widget getTopicWidget(Pin pin) {
    if (pin.topic == null) return Container();
    return Container(
      height: 28.0,
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      margin: EdgeInsets.only(right: 16.0, bottom: 8.0),
      decoration: BoxDecoration(
          border: Border.all(color: ConfigColor.colorPrimary, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Text(
          pin.topic.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.0, color: ConfigColor.colorPrimary),
        ),
    );
  }
}

class Model extends Object with BannerWithEval {
  final String imgUrl;

  Model({this.imgUrl});

  @override
  get bannerUrl => imgUrl;
}
