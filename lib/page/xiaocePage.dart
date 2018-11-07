import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:juejin_flutter/config/config_color.dart';
import 'package:juejin_flutter/model/entry.dart';
import 'package:juejin_flutter/model/xiaoce.dart';

Future<List<Xiaoce>> fetchPost() async {
  final response = await http.get(
      'https://xiaoce-timeline-api-ms.juejin.im/v1/getListByLastTime?&src=web&alias=&pageNum=1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var decode = json.decode(response.body);
    var xiaoceList = decode['d'];
    var list = List<Xiaoce>();
    for (var value in xiaoceList) {
      try {
        var entry = Xiaoce.fromJson(value);
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

class XiaocePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _XiaocePageState();
  }
}

class _XiaocePageState extends State<XiaocePage> {
  List<Xiaoce> items = List<Xiaoce>();
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
      title: "小册",
      home: Scaffold(
        appBar: AppBar(
          title: Text("小册"),
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

  Widget getItemView(Xiaoce xiaoce) {
    return Container(
      decoration: BoxDecoration(
          color: ConfigColor.colorContentBackground,
          border: BorderDirectional(
              bottom: BorderSide(color: ConfigColor.colorDivider, width: 0.5))),
      padding: EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
                boxShadow: [
                  new BoxShadow(color: Color(0x33000000), blurRadius: 4.0, offset: Offset(1.0, 1.0))
                ]
            ),
            margin: EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Image.network(xiaoce.img,
                fit: BoxFit.cover, width: 72.0, height: 100.0),
          ),
          Expanded(
            child: Container(
              height: 100.0,
              margin: EdgeInsets.only(left: 12.0, bottom: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      xiaoce.title,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0, color: ConfigColor.colorText1),
                    ),
                  ),
                  Container(
                    child: Text(
                      xiaoce.userData.username,
                      style: TextStyle(
                          fontSize: 14.0, color: ConfigColor.colorText2),
                    ),
                  ),
                  Container(
                    child: Text(
                      "${xiaoce.buyCount} 人购买",
                      style: TextStyle(
                          fontSize: 12.0, color: ConfigColor.colorText3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 28.0,
            width: 72.0,
            margin: EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
            decoration: BoxDecoration(
                color: Color(0xFFf0f7ff),
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Center(child: Text(
              "￥${xiaoce.price}",
              textAlign: TextAlign.center,
              style: TextStyle( fontWeight: FontWeight.bold, fontSize: 15.0, color: ConfigColor.colorPrimary),
            ),),
          )
        ],
      ),
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
