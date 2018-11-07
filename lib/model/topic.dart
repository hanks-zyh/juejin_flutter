class Topic {
  int msgsCount;
  int    followersCount;
  int    attendersCount;
  String icon;
  String description;
  String title;
  String objectId;
  String createdAt;
  String updatedAt;
  String latestMsgCreatedAt;

  Topic();

  factory Topic.fromJson(Map<String, dynamic> json) {
    var topic = Topic();
    topic.objectId = json['objectId'];
    topic.msgsCount = json['msgsCount'];
    topic.followersCount = json['followersCount'];
    topic.attendersCount = json['attendersCount'];
    topic.icon = json['icon'];
    topic.description = json['description'];
    topic.title = json['title'];
    topic.objectId = json['objectId'];
    topic.createdAt = json['createdAt'];
    topic.updatedAt = json['updatedAt'];
    topic.latestMsgCreatedAt = json['latestMsgCreatedAt'];
    return topic;
  }
}
