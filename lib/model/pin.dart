
import 'package:juejin_flutter/model/topic.dart';
import 'package:juejin_flutter/model/user.dart';

class Pin {
  int commentCount;
  int likedCount;
  bool isLiked;
  String objectId;
  String title;
  String content;
  String url;
  String urlTitle;
  String urlPic;
  List<String> pictures;
  String createdAt;
  User user;
  Topic topic;

  Pin();

  factory Pin.fromJson(Map<String, dynamic> json) {
    var pin = Pin();
    pin.objectId = json['objectId'];
    pin.title = json['title'];
    pin.content = json['content'];
    pin.commentCount = json['commentCount'];
    pin.likedCount = json['likedCount'];
    pin.createdAt = json['createdAt'];
    pin.url = json['url'];
    pin.urlTitle = json['urlTitle'];
    pin.urlPic = json['urlPic'];
    pin.pictures = List<String>();
    for (var value in json['pictures']) {
      pin.pictures.add(value);
    }
    pin.user = User.fromJson(json['user']);
    pin.topic = Topic.fromJson(json['topic']);
    return pin;
  }

  @override
  String toString() {
    return 'Pin{commentCount: $commentCount, likedCount: $likedCount, isLiked: $isLiked, objectId: $objectId, title: $title, content: $content, url: $url, urlTitle: $urlTitle, urlPic: $urlPic, pictures: $pictures, createdAt: $createdAt, user: $user, topic: $topic}';
  }

}