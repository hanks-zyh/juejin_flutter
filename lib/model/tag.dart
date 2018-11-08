class Tag{
  Tag();
  String id;
  String title;

  factory Tag.formJson(Map<String, dynamic> json){
    Tag tag = Tag();
    tag.id = json['id'];
    tag.title = json['title'];
    return tag;
  }
}