class ImUser {
  String avatar;
  String address;
  String nickname;
  String token;
  String phone;
  String remarks;
  int id;
  int uid;
  int platform;
  int online;
  int updateAt;
  int lastActivity;
  int createAt;

  ImUser(
      {this.avatar,
      this.address,
      this.nickname,
      this.token,
      this.phone,
      this.remarks,
      this.id,
      this.uid,
      this.platform,
      this.online,
      this.updateAt,
      this.lastActivity,
      this.createAt});

  ImUser.fromJson(Map<String, dynamic> json) {
    this.avatar = json['avatar'];
    this.address = json['address'];
    this.nickname = json['nickname'];
    this.token = json['token'];
    this.phone = json['phone'];
    this.remarks = json['remarks'];
    this.id = json['id'];
    this.uid = json['uid'];
    this.platform = json['platform'];
    this.online = json['online'];
    this.updateAt = json['update_at'];
    this.lastActivity = json['last_activity'];
    this.createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['address'] = this.address;
    data['nickname'] = this.nickname;
    data['token'] = this.token;
    data['phone'] = this.phone;
    data['remarks'] = this.remarks;
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['platform'] = this.platform;
    data['online'] = this.online;
    data['update_at'] = this.updateAt;
    data['last_activity'] = this.lastActivity;
    data['create_at'] = this.createAt;
    return data;
  }
}
