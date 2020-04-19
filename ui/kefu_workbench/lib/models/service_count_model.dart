class ServicesCountModel {
  String count;
  String id;
  String nickname;
  String username;

  ServicesCountModel({this.count, this.id, this.nickname, this.username});

  ServicesCountModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    id = json['id'];
    nickname = json['nickname'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['username'] = this.username;
    return data;
  }
}