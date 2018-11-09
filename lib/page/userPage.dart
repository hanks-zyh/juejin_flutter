import 'package:flutter/material.dart';
import 'package:juejin_flutter/config/config_color.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPage();
  }
}

class _UserPage extends State<UserPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "user",
      home: Scaffold(
          appBar: AppBar(
            title: Text("我"),
            backgroundColor: ConfigColor.colorPrimary,
            elevation: 1.0,
          ),
          body: SingleChildScrollView(
              child: Column(children: <Widget>[
            Container(
              height: 80.0,
              margin: EdgeInsets.only(top: 12.0),
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
              decoration: BoxDecoration(
                  color: ConfigColor.colorContentBackground,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 1.0,
                        offset: Offset(0.0, 0.5)),
                  ]),
              child: Row(children: <Widget>[
                Container(
                  height: 48.0,
                  width: 48.0,
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://user-gold-cdn.xitu.io/2018/7/6/1646db21990a14f9"),
                      backgroundColor: ConfigColor.colorWindowBackground),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                        child: Text(
                          "码农码畜",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: ConfigColor.colorText1),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                        child: Text(
                          "宇航员 @ 航天局",
                          style: TextStyle(
                              fontSize: 12.0, color: ConfigColor.colorText2),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: ConfigColor.colorDivider,
                ),
              ]),
            ),

            // items
            Container(
                margin: EdgeInsets.only(top: 12.0),
                decoration: BoxDecoration(
                    color: ConfigColor.colorContentBackground,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 1.0,
                          offset: Offset(0.0, 0.5)),
                    ]),
                child: Column(
                  children: <Widget>[
                    getSettingItem(
                        Icons.notifications, Color(0xFF0076FF), "消息中心", ""),
                    getSettingItem(
                        Icons.favorite, Color(0xFF6CBD45), "我赞过的", ""),
                    getSettingItem(
                        Icons.grade, Color(0xFFffc347), "收藏集合", "50个"),
                    getSettingItem(Icons.shopping_basket, Color(0xFFffbe4b),
                        "已购小册", "10本"),
                    getSettingItem(Icons.remove_red_eye, Color(0xFFABB4BF),
                        "阅读历史", "7001篇"),
                    getSettingItem(
                        Icons.loyalty, Color(0xFFABB4BF), "标签管理", "14个"),
                  ],
                )),

            // items
            Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
                decoration: BoxDecoration(
                    color: ConfigColor.colorContentBackground,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 1.0,
                          offset: Offset(0.0, 0.5)),
                    ]),
                child: Column(
                  children: <Widget>[
                    getSettingItem(
                        Icons.brightness_medium, Color(0xFFABB4BF), "夜间模式", ""),
                    getSettingItem(
                        Icons.feedback, Color(0xFFABB4BF), "意见反馈", ""),
                    getSettingItem(
                        Icons.settings, Color(0xFFABB4BF), "应用设置", ""),
                  ],
                )),
          ]))),
    );
  }

  Widget getSettingItem(IconData icon, Color color, String title, String text) {
    return Column(children: <Widget>[
      Container(
        height: 48.0,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20.0,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: ConfigColor.colorText1,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Text(
              text,
              style: TextStyle(fontSize: 12.0, color: ConfigColor.colorText2),
            ),
          ],
        ),
      ),
      Container(
        height: 0.5,
        color: ConfigColor.colorDivider,
      )
    ]);
  }
}
