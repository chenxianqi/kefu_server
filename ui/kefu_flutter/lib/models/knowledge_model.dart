class KnowledgeModel {
  String title;
  String subTitle;
  String content;
  int id;
  int uid;
  int platform;
  int updateAt;
  int createAt;

  KnowledgeModel(
      {this.title,
      this.subTitle,
      this.content,
      this.id,
      this.uid,
      this.platform,
      this.updateAt,
      this.createAt});

  KnowledgeModel.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.subTitle = json['sub_title'];
    this.content = json['content'];
    this.id = json['id'];
    this.uid = json['uid'];
    this.platform = json['platform'];
    this.updateAt = json['update_at'];
    this.createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['sub_title'] = this.subTitle;
    data['content'] = this.content;
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['platform'] = this.platform;
    data['update_at'] = this.updateAt;
    data['create_at'] = this.createAt;
    return data;
  }
}
