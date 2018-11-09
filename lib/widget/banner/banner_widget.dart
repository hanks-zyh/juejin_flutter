import 'package:flutter/material.dart';
import './banner_evalutor.dart';
import 'dart:async';

class BannerWidget extends StatefulWidget{
  final List<BannerWithEval> data;
  final int height,delayTime,duration;
  final Curve curve;
  final ItemBuild build;
  final IndicatorBuild indicator;
  final OnClick onClick;

  BannerWidget({
    Key key,
    @required this.data,
    @required this.curve,
    this.indicator,
    this.build,
    this.onClick,
    this.height = 160,
    this.delayTime = 4000,
    this.duration = 1000,
  }): super(key : key);

  createState() => BannerState();
}

class BannerState extends State<BannerWidget> {
  Timer timer;
  PageController controller;
  int position,currentPage;
  List<BannerWithEval> bannerList = [];
  bool isRoll = true;

  @override
  void initState() {
    position = 0;
    currentPage = -1;
    controller = PageController(initialPage: getRealCount());
    restTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    restData();
    return Container(
        height: widget.height.toDouble(),
        color: Colors.grey,
        child: Stack(
          children: <Widget>[
            pageView(),
            indicator(),
          ],
        ));
  }

  Widget pageView() {
    return Listener(
      onPointerMove: (event){
        isRoll = true;
      },
      onPointerDown: (event){
        isRoll = false;
      },
      onPointerUp: (event){
        isRoll = true;
      },
      onPointerCancel: (event){
        isRoll = true;
      },
      child: NotificationListener(
        onNotification: (scrollNotification){
          if (currentPage == -1) {
            isRoll = true;
          }else if (scrollNotification is ScrollEndNotification || scrollNotification is UserScrollNotification) {
            if (currentPage == 0) {
              setState(() {
                currentPage = getRealCount();
                controller.jumpToPage(currentPage);
              });
            }
            isRoll = true;
          } else {
            isRoll = false;
          }
        },
        child: PageView.custom(
          controller: controller,
          onPageChanged: (index) {
            currentPage = index;
            position = index % getRealCount();
            setState(() {});
          },
          physics: const PageScrollPhysics(parent: const BouncingScrollPhysics()),
          childrenDelegate: SliverChildBuilderDelegate((context, index){
            int current =  index % getRealCount();
            BannerWithEval bannerWithEval = bannerList[current];
            return GestureDetector(
              onTap: () => widget.onClick(current, bannerWithEval),
              child: widget.build != null ? widget.build(current) : BannerItem(
                url: bannerWithEval.bannerUrl,
              ),
            );
          },
            childCount: bannerList.length,
          ),
        ),
      ),
    );
  }

  Widget indicator() {
    return widget.indicator == null ? Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 20.0,
          padding: EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: circularPoint(getRealCount()),
          ),
        )) : widget.indicator(position,getRealCount());
  }

  List<Widget> circularPoint(int count) {
    List<Widget> children = [];
    for (var i = 0; i < count; i++) {
      children.add(Container(
        width: position == i ? 16.0: 8.0,
        height: 2.0,
        margin: EdgeInsets.only(left: 4.0,top: 0.0,right: 4.0,bottom: 0.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: position == i ? Colors.white : Colors.white54,
        ),
      ));
    }
    return children;
  }

  void restTime() {
    if (timer == null){
      timer = Timer.periodic(Duration(milliseconds: widget.delayTime), (timer) {
        if (isRoll){
          if (currentPage == -1){
            currentPage = 0;
            controller.jumpToPage(currentPage);
            return;
          }
          currentPage++;
          controller.nextPage(duration: Duration(milliseconds: widget.duration),
              curve: widget.curve);
        }
      });
    }
  }

  void cancelTime(){
    timer?.cancel();
    timer = null;
  }

  void restData(){
    for (int i = 0;i<2;i++){
      bannerList.addAll(widget.data);
    }
  }

  int getRealCount() => widget.data.length;

  @override
  void dispose() {
    cancelTime();
    controller?.dispose();
    controller = null;
    super.dispose();
  }
}

class BannerItem extends StatefulWidget{
  final String url;
  BannerItem({
    Key key,
    @required this.url,
  }): super(key : key);

  @override
  createState() => ItemState();
}

class ItemState extends State<BannerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 160.0,
        width: double.infinity,
        color: Colors.black38,
        child:  Image.network(widget.url, fit: BoxFit.cover,),
    );
  }
}

//Banner中滚动的Item
typedef Widget ItemBuild(int position);

//在这添加自定义的指示器，指示器位置自定义请使用Align部件，默认圆点
typedef Widget IndicatorBuild(int position,int counmt);

//点击监听
typedef void OnClick(int position, BannerWithEval bannerWithEval);