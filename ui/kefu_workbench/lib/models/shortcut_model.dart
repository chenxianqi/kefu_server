class ShortcutModel {
  int id;
  int uid;
  String title;
  String content;
  int updateAt;
  int createAt;

  ShortcutModel(
      {this.id,
      this.uid,
      this.title,
      this.content,
      this.updateAt,
      this.createAt});

  ShortcutModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    title = json['title'];
    content = json['content'];
    updateAt = json['update_at'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['title'] = this.title;
    data['content'] = this.content;
    data['update_at'] = this.updateAt;
    data['create_at'] = this.createAt;
    return data;
  }
}