class User {
  String avatarLarge;
  String username;
  String jobTitle;
  String company;
  String objectId;
  User();

  factory User.fromJson(Map<String, dynamic> jsonUser) {
    var user = User();
    user.objectId = jsonUser['objectId'];
    user.avatarLarge = jsonUser['avatarLarge'];
    user.username = jsonUser['username'];
    user.jobTitle = jsonUser['jobTitle'];
    user.company = jsonUser['company'];
    return user;
  }
}