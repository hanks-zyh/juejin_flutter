import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:juejin_flutter/config/config_color.dart';
import 'package:juejin_flutter/model/pin.dart';
import 'package:juejin_flutter/widget/banner/banner_evalutor.dart';

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

  var tabs = ['话题', '推荐', '关注'];

  Widget getTabItemWidget(int index) {
    return Container(
      height: kToolbarHeight,
      child: Center(
        child: Text(
          tabs[index],
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  var width = 360.0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var tabHeight = 40.0 + statusBarHeight;
    return MaterialApp(
        home: DefaultTabController(
      length: tabs.length,
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: tabHeight - 22.0),
            child: RefreshIndicator(
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
          Container(
              decoration: BoxDecoration(
                  color: ConfigColor.colorPrimary,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x44000000),
                        blurRadius: 3.0,
                        offset: Offset(0.0, 1.0))
                  ]),
              padding: EdgeInsets.only(top: statusBarHeight),
              height: tabHeight,
              width: double.infinity,
              child: Center(
                child: TabBar(
                  isScrollable: true,
                  indicatorWeight: 2.5,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: ConfigColor.colorContentBackground,
                  tabs: <Widget>[
                    getTabItemWidget(0),
                    getTabItemWidget(1),
                    getTabItemWidget(2),
                  ],
                ),
              )),
        ],
      )),
    ));
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
            EdgeInsets.only(top: 8.0, right: 16.0, bottom: 8.0, left: 16.0),
        margin: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
            color: ConfigColor.colorContentBackground,
            boxShadow: [
              new BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 1.0,
                  offset: Offset(0.0, 0.5))
            ]),
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
                      padding: const EdgeInsets.all(1.0),
                      // borde width
                      decoration: new BoxDecoration(
                        color: Color(0xffd7dade), // border color
                        shape: BoxShape.circle,
                      ),
                      width: 24.0,
                      height: 24.0),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 8.0),
                      child: Text(
                        pin.user.username,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 13.0, color: ConfigColor.colorText2),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "3小时前",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 10.0, color: ConfigColor.colorText3),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0.0, bottom: 8.0),
              child: Text(
                pin.content,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
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
                          fontSize: 12.0, color: ConfigColor.colorText3)),
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
                          fontSize: 12.0, color: ConfigColor.colorText3)),
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
                          fontSize: 12.0, color: ConfigColor.colorText3)),
                ),
              ],
            ),
          )
        ],
      ),
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

  Widget getImgInGridView(
      String url, double size, bool marginLeft, bool marginTop) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ConfigColor.colorDivider),
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      margin: EdgeInsets.only(
          top: marginTop ? 4.0 : 0.0, left: marginLeft ? 4.0 : 0.0),
      height: size,
      width: size,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(3.0),
        child: Image.network(
          url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget getPicturesWidget(Pin pin) {
    if (pin.pictures == null || pin.pictures.length <= 0) return Container();
    var pictures = pin.pictures;
    if (pictures.length == 1) {
      var url = pictures[0];
      var w = 200;
      var h = 200;
      try {
        var wStr = Uri.parse(url).queryParameters['w'];
        var hStr = Uri.parse(url).queryParameters['h'];
        w = int.parse(wStr);
        h = int.parse(hStr);
      } catch (e) {}

      var imgW = 200.0;
      var imgH = 200.0;
      if (w >= h) {
        imgW = 200.0;
        imgH = h / w * imgW;
      } else {
        imgH = 200.0;
        imgW = h / w * imgH;
      }

      return Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: ConfigColor.colorDivider),
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
        ),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(3.0),
          child: Image.network(
            pictures[0],
            fit: BoxFit.cover,
          ),
        ),
        width: imgW,
        height: imgH,
      );
    }
    if (pictures.length == 2) {
      double size = (width - 32 - 4) / 2.0;
      return Row(
        children: <Widget>[
          getImgInGridView(pictures[0], size, false, false),
          getImgInGridView(pictures[1], size, true, false),
        ],
      );
    } else if (pictures.length == 3) {
      double size = (width - 32 - 8) / 3.0;
      return Row(
        children: <Widget>[
          getImgInGridView(pictures[0], size, false, false),
          getImgInGridView(pictures[1], size, true, false),
          getImgInGridView(pictures[2], size, true, false),
        ],
      );
    } else if (pictures.length == 4) {
      double size = (width - 32 - 4) / 2.0;
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              getImgInGridView(pictures[0], size, false, false),
              getImgInGridView(pictures[1], size, true, false),
            ],
          ),
          Row(
            children: <Widget>[
              getImgInGridView(pictures[2], size, false, true),
              getImgInGridView(pictures[3], size, true, true),
            ],
          )
        ],
      );
    } else if (pictures.length == 5) {
      double size = (width - 32 - 4) / 2.0;
      double size1 = (width - 32 - 8) / 3.0;
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              getImgInGridView(pictures[0], size, false, false),
              getImgInGridView(pictures[1], size, true, false),
            ],
          ),
          Row(
            children: <Widget>[
              getImgInGridView(pictures[2], size1, false, true),
              getImgInGridView(pictures[3], size1, true, true),
              getImgInGridView(pictures[4], size1, true, true),
            ],
          )
        ],
      );
    } else if (pictures.length == 6) {
      double size = (width - 32 - 8) / 3.0;
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              getImgInGridView(pictures[0], size, false, false),
              getImgInGridView(pictures[1], size, true, false),
              getImgInGridView(pictures[2], size, true, false),
            ],
          ),
          Row(
            children: <Widget>[
              getImgInGridView(pictures[3], size, false, true),
              getImgInGridView(pictures[4], size, true, true),
              getImgInGridView(pictures[5], size, true, true),
            ],
          )
        ],
      );
    } else if (pictures.length == 7) {
      double size = (width - 32 - 8) / 3.0;
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              getImgInGridView(pictures[0], width - 32.0, false, false),
            ],
          ),
          Row(
            children: <Widget>[
              getImgInGridView(pictures[1], size, false, true),
              getImgInGridView(pictures[2], size, true, true),
              getImgInGridView(pictures[3], size, true, true),
            ],
          ),
          Row(
            children: <Widget>[
              getImgInGridView(pictures[4], size, false, true),
              getImgInGridView(pictures[5], size, true, true),
              getImgInGridView(pictures[6], size, true, true),
            ],
          )
        ],
      );
    } else if (pictures.length == 8) {
      double size = (width - 32 - 8) / 3.0;
      double size1 = (width - 32 - 4) / 2.0;
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              getImgInGridView(pictures[0], size1, false, false),
              getImgInGridView(pictures[1], size1, true, false),
            ],
          ),
          Row(
            children: <Widget>[
              getImgInGridView(pictures[2], size, false, true),
              getImgInGridView(pictures[3], size, true, true),
              getImgInGridView(pictures[4], size, true, true),
            ],
          ),
          Row(
            children: <Widget>[
              getImgInGridView(pictures[5], size, false, true),
              getImgInGridView(pictures[6], size, true, true),
              getImgInGridView(pictures[7], size, true, true),
            ],
          )
        ],
      );
    } else if (pictures.length == 9) {
      double size = (width - 32 - 8) / 3.0;
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              getImgInGridView(pictures[0], size, false, false),
              getImgInGridView(pictures[1], size, true, false),
              getImgInGridView(pictures[2], size, true, false),
            ],
          ),
          Row(
            children: <Widget>[
              getImgInGridView(pictures[3], size, false, true),
              getImgInGridView(pictures[4], size, true, true),
              getImgInGridView(pictures[5], size, true, true),
            ],
          ),
          Row(
            children: <Widget>[
              getImgInGridView(pictures[6], size, false, true),
              getImgInGridView(pictures[7], size, true, true),
              getImgInGridView(pictures[8], size, true, true),
            ],
          )
        ],
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
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
      margin: EdgeInsets.only(right: 16.0, bottom: 8.0, top: 4.0),
      decoration: BoxDecoration(
          color: Color(0xffF6F8FA),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Text(
        "# ${pin.topic.title}",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11.0, color: ConfigColor.colorPrimary),
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
