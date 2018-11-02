
class User {
  String avatarLarge;
  String username;
  String jobTitle;
  String company;
  String objectId;

  User();
}

class Category {
  String id;
  String name;
  String title;

  Category();
}

class Entry {
  int commentsCount;
  int collectionCount;
  String objectId;
  String title;
  String content;
  String originalUrl;
  String type;
  String createdAt;
  User user;
  Category category;

  Entry();

  factory Entry.fromJson(Map<String, dynamic> json) {
    var entry = Entry();
    entry.objectId = json['objectId'];
    entry.title = json['title'];
    entry.content = json['content'];
    entry.originalUrl = json['originalUrl'];
    entry.type = json['type'];
    entry.createdAt = json['createdAt'];
    entry.commentsCount = json['commentsCount'];
    entry.collectionCount = json['collectionCount'];

    var user = User();
    var jsonUser = json['user'];
    user.objectId = jsonUser['objectId'];
    user.avatarLarge = jsonUser['avatarLarge'];
    user.username = jsonUser['username'];
    user.jobTitle = jsonUser['jobTitle'];
    user.company = jsonUser['company'];
    entry.user = user;

    var category = Category();
    var categoryJson = json['category'];
    category.id = categoryJson['id'];
    category.name = categoryJson['name'];
    category.title = categoryJson['title'];

    entry.category = category;
    return entry;
  }
}