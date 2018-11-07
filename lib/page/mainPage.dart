// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:juejin_flutter/config/config_color.dart';
import 'package:juejin_flutter/page/explorePage.dart';
import 'package:juejin_flutter/page/homePage.dart';
import 'package:juejin_flutter/page/pinPage.dart';
import 'package:juejin_flutter/page/userPage.dart';
import 'package:juejin_flutter/page/xiaocePage.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/page/main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ['首页', '动态', '发现', '小测', '我的'];

  /*
   * 存放三个页面，跟fragmentList一样
   */
  var _pageList;

  /*
   * 根据选择获得对应的normal或是press的icon
   */
  Widget getTabIcon(int curIndex) {
    var image;
    if (curIndex == _tabIndex) {
      image = tabImages[curIndex][1];
    } else {
      image = tabImages[curIndex][0];
    }
    return new Center(
      child: image,
    );
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Container getTabTitle(int curIndex) {
    return Container(
      width: 0.0,
      height: 0.0,
    );
  }

  /*
   * 根据image路径获取图片
   */
  Image getTabImage(path) {
    return new Image.asset(path, width: 32.0, height: 32.0);
  }

  void initData() {
    /*
     * 初始化选中和未选中的icon
     */
    tabImages = [
      [
        getTabImage('assets/tab_home_normal.png'),
        getTabImage('assets/tab_home.png')
      ],
      [
        getTabImage('assets/tab_activity_normal.png'),
        getTabImage('assets/tab_activity.png')
      ],
      [
        getTabImage('assets/tab_explore_normal.png'),
        getTabImage('assets/tab_explore.png')
      ],
      [
        getTabImage('assets/tab_xiaoce_normal.png'),
        getTabImage('assets/tab_xiaoce.png')
      ],
      [
        getTabImage('assets/tab_profile_normal.png'),
        getTabImage('assets/tab_profile.png')
      ],
    ];
    /*
     * 三个子界面
     */
    _pageList = [
      new HomePage(),
      new PinPage(),
      new ExplorePage(),
      new XiaocePage(),
      new UserPage(),
    ];
  }

  Widget getBottomIcon(var index) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () {
              setState(() {
                _tabIndex = index;
              });
            },
            child: getTabIcon(index)),
      ),
      flex: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    //初始化数据
    initData();

    return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: _pageList[_tabIndex],
              flex: 1,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ConfigColor.colorContentBackground,
                  boxShadow: [
                    new BoxShadow(color: Color(0x18000000), blurRadius: 3.0)
                  ]),
              height: 48.0,
              child: Row(children: <Widget>[
                getBottomIcon(0),
                getBottomIcon(1),
                getBottomIcon(2),
                getBottomIcon(3),
                getBottomIcon(4),
              ]),
            ),
          ],
        ),
    );
  }
}
