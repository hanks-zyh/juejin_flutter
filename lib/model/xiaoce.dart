
import 'package:juejin_flutter/model/user.dart';

class Xiaoce {
  int buyCount;
  double price;
  String id;
  String title;
  String desc;
  String img;
  String createdAt;
  User userData;

  Xiaoce();

  factory Xiaoce.fromJson(Map<String, dynamic> json) {
    var xiaoce = Xiaoce();
    xiaoce.id = json['id'];
    xiaoce.title = json['title'];
    xiaoce.desc = json['desc'];
    xiaoce.img = json['img'];
    xiaoce.buyCount = json['buyCount'];
    xiaoce.createdAt = json['createdAt'];
    xiaoce.price = json['price'];

    var user = User();
    var jsonUser = json['userData'];
    user.objectId = jsonUser['objectId'];
    user.avatarLarge = jsonUser['avatarLarge'];
    user.username = jsonUser['username'];
    user.jobTitle = jsonUser['jobTitle'];
    user.company = jsonUser['company'];
    xiaoce.userData = user;

    return xiaoce;
  }
}