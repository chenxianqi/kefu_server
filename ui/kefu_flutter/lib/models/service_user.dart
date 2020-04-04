class ServiceUser {
  String nickname;
  String avatar;
  int id;

  ServiceUser({this.nickname, this.avatar, this.id});

  ServiceUser.fromJson(Map<String, dynamic> json) {
    this.nickname = json['nickname'];
    this.avatar = json['avatar'];
    this.id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['id'] = this.id;
    return data;
  }
}
