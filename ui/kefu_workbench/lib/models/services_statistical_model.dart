class ServicesStatisticalModel {
  String createAt;
  String id;
  String isReception;
  String nickname;
  String platform;
  String serviceAccount;
  String transferAccount;
  String userAccount;

  ServicesStatisticalModel(
      {this.createAt,
      this.id,
      this.isReception,
      this.nickname,
      this.platform,
      this.serviceAccount,
      this.transferAccount,
      this.userAccount});

  ServicesStatisticalModel.fromJson(Map<String, dynamic> json) {
    createAt = json['create_at'];
    id = json['id'];
    isReception = json['is_reception'];
    nickname = json['nickname'];
    platform = json['platform'];
    serviceAccount = json['service_account'];
    transferAccount = json['transfer_account'];
    userAccount = json['user_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create_at'] = this.createAt;
    data['id'] = this.id;
    data['is_reception'] = this.isReception;
    data['nickname'] = this.nickname;
    data['platform'] = this.platform;
    data['service_account'] = this.serviceAccount;
    data['transfer_account'] = this.transferAccount;
    data['user_account'] = this.userAccount;
    return data;
  }
}