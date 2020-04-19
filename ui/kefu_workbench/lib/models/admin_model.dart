class AdminModel {
  int id;
  String avatar;
  String username;
  String nickname;
  String password;
  String phone;
  String token;
  String autoReply;
  int online;
  int root;
  int currentConUser;
  int lastActivity;
  int updateAt;
  int createAt;

  AdminModel(
      {this.id,
      this.avatar,
      this.username,
      this.nickname,
      this.password,
      this.phone,
      this.token,
      this.autoReply,
      this.online,
      this.root,
      this.currentConUser,
      this.lastActivity,
      this.updateAt,
      this.createAt});

  AdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    username = json['username'];
    nickname = json['nickname'];
    password = json['password'];
    phone = json['phone'];
    token = json['token'];
    autoReply = json['auto_reply'];
    online = json['online'];
    root = json['root'];
    currentConUser = json['current_con_user'];
    lastActivity = json['last_activity'];
    updateAt = json['update_at'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['username'] = this.username;
    data['nickname'] = this.nickname;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['token'] = this.token;
    data['auto_reply'] = this.autoReply;
    data['online'] = this.online;
    data['root'] = this.root;
    data['current_con_user'] = this.currentConUser;
    data['last_activity'] = this.lastActivity;
    data['update_at'] = this.updateAt;
    data['create_at'] = this.createAt;
    return data;
  }
}