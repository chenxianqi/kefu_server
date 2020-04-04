class ImTokenInfo {
  String appId;
  String appPackage;
  String appAccount;
  String miUserId;
  String miUserSecurityKey;
  String token;
  String feDomainName;
  String relayDomainName;
  int miChid;
  int regionBucket;

  ImTokenInfo(
      {this.appId,
      this.appPackage,
      this.appAccount,
      this.miUserId,
      this.miUserSecurityKey,
      this.token,
      this.feDomainName,
      this.relayDomainName,
      this.miChid,
      this.regionBucket});

  ImTokenInfo.fromJson(Map<String, dynamic> json) {
    this.appId = json['appId'];
    this.appPackage = json['appPackage'];
    this.appAccount = json['appAccount'];
    this.miUserId = json['miUserId'];
    this.miUserSecurityKey = json['miUserSecurityKey'];
    this.token = json['token'];
    this.feDomainName = json['feDomainName'];
    this.relayDomainName = json['relayDomainName'];
    this.miChid = json['miChid'];
    this.regionBucket = json['regionBucket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appId'] = this.appId;
    data['appPackage'] = this.appPackage;
    data['appAccount'] = this.appAccount;
    data['miUserId'] = this.miUserId;
    data['miUserSecurityKey'] = this.miUserSecurityKey;
    data['token'] = this.token;
    data['feDomainName'] = this.feDomainName;
    data['relayDomainName'] = this.relayDomainName;
    data['miChid'] = this.miChid;
    data['regionBucket'] = this.regionBucket;
    return data;
  }
}
