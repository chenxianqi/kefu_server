class Robot {
  int id;
  String nickname;
  String avatar;
  String welcome;
  String understand;
  String artificial;
  String keyword;
  String timeoutText;
  String noServices;
  String loogTimeWaitText;
  int isRun;
  int system;
  int platform;
  int updateAt;
  int createAt;

  Robot(
      {this.id,
      this.nickname,
      this.avatar,
      this.welcome,
      this.understand,
      this.artificial,
      this.keyword,
      this.timeoutText,
      this.noServices,
      this.loogTimeWaitText,
      this.isRun,
      this.system,
      this.platform,
      this.updateAt,
      this.createAt});

  Robot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    welcome = json['welcome'];
    understand = json['understand'];
    artificial = json['artificial'];
    keyword = json['keyword'];
    timeoutText = json['timeout_text'];
    noServices = json['no_services'];
    loogTimeWaitText = json['loog_time_wait_text'];
    isRun = json['switch'];
    system = json['system'];
    platform = json['platform'];
    updateAt = json['update_at'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['welcome'] = this.welcome;
    data['understand'] = this.understand;
    data['artificial'] = this.artificial;
    data['keyword'] = this.keyword;
    data['timeout_text'] = this.timeoutText;
    data['no_services'] = this.noServices;
    data['loog_time_wait_text'] = this.loogTimeWaitText;
    data['switch'] = this.isRun;
    data['system'] = this.system;
    data['platform'] = this.platform;
    data['update_at'] = this.updateAt;
    data['create_at'] = this.createAt;
    return data;
  }
}
