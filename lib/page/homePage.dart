import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:juejin_flutter/config/config_color.dart';
import 'package:juejin_flutter/model/entry.dart';
import 'package:juejin_flutter/page/webpage.dart';

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

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
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

  var tabs = ['首页', 'Android', 'iOS'];

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

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    var tabHeight = 40.0 + statusBarHeight;
    return MaterialApp(
        title: "Home",
        home: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: tabHeight - 13.0),
                  child: RefreshIndicator(
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
                  child: TabBar(
                    isScrollable: true,
                    indicatorWeight: 2.5,
                    indicatorColor: ConfigColor.colorContentBackground,
                    tabs: <Widget>[
                      getTabItemWidget(0),
                      getTabItemWidget(1),
                      getTabItemWidget(2),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  /// 创建一个平移变换
  /// 跳转过去查看源代码，可以看到有各种各样定义好的变换
   SlideTransition createTransition(
      Animation<double> animation, Widget child) {
    return new SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(animation),
      child: child, // child is the value returned by pageBuilder
    );
  }

  Widget getItemView(Entry entry) {
    return InkWell(
        onTap: () {

//          Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
//              (BuildContext context, Animation<double> animation,
//              Animation<double> secondaryAnimation) {
//            return WebPage(url:entry.originalUrl);
//          }, transitionsBuilder: (
//              BuildContext context,
//              Animation<double> animation,
//              Animation<double> secondaryAnimation,
//              Widget child,
//              ) {
//            // 添加一个平移动画
//            return createTransition(animation, child);
//          }));

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WebPage(url:entry.originalUrl)));
        },
        child: Container(
            margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
            child: Ink(
              padding: EdgeInsets.only(top: 16.0, right: 16.0, bottom: 4.0),
              decoration: BoxDecoration(
                  color: ConfigColor.colorContentBackground,
                  boxShadow: [
                    new BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 1.0,
                        offset: Offset(0.0, 0.5))
                  ]),
              child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 16.0),
                          padding: const EdgeInsets.all(1.0),
                          // borde width
                          child: CircleAvatar(
                            backgroundImage:
                            NetworkImage(entry.user.avatarLarge),
                            backgroundColor: ConfigColor.colorWindowBackground,
                          ),
                          decoration: new BoxDecoration(
                            color: Color(0xffd7dade), // border color
                            shape: BoxShape.circle,
                          ),
                          width: 24.0,
                          height: 24.0),
                      Expanded(
                        child: Container(
                          child: Text(
                            entry.user.username,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 12.0, color: ConfigColor.colorText1),
                          ),
                          margin: EdgeInsets.only(left: 8.0),
                        ),
                      ),
                      getTagWidget(entry),
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
                    padding: EdgeInsets.only(top: 8.0, left: 16.0),
                  ),
                  Container(
                    child: Text(
                      entry.content.trim(),
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: ConfigColor.colorText2,
                          height: 1.2),
                    ),
                    padding: EdgeInsets.only(top: 4.0, left: 16.0),
                  ),
                  Container(
                    child: Row(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 4.0, left: 16.0),
                            child: Image.asset(
                                "assets/timeline_like_normal.png",
                                width: 16.0,
                                height: 16.0),
                          ),
                          Container(
                            child: Text(
                              "${entry.collectionCount}",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: ConfigColor.colorText3),
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
                                  fontSize: 12.0,
                                  color: ConfigColor.colorText3),
                            ),
                          ),
                        ],
                      ),
                    ]),
                    height: 40.0,
                  )
                ]),
            )
        ));
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

Widget getTagWidget(Entry entry) {
  if (entry == null || entry.tags == null || entry.tags.isEmpty) {
    return Container(
      child: Text("nn"),
    );
  }

  var text = entry.tags[0].title;
  if (entry.tags.length > 1) {
    text += " / ${entry.tags[1].title}";
  }

  return Container(
    child: Text(
      text,
      style: TextStyle(
        color: ConfigColor.colorText3,
        fontSize: 12.0,
      ),
    ),
  );
}
