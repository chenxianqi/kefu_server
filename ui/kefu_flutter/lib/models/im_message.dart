import 'dart:convert';

class ImMessage {
  String bizType;
  String version;
  dynamic payload;
  int fromAccount;
  int toAccount;
  int timestamp;
  int read;
  int key;
  int transferAccount;
  bool isShowCancel = false;
  int uploadProgress;
  String avatar;
  String nickname;
  bool isShowDate = false;

  ImMessage(
      {this.bizType,
      this.key,
      this.isShowDate = false,
      this.uploadProgress,
      this.version,
      this.avatar,
      this.nickname,
      this.isShowCancel = false,
      this.payload,
      this.fromAccount,
      this.toAccount,
      this.timestamp,
      this.read,
      this.transferAccount});

  ImMessage.fromJson(Map<String, dynamic> json) {
    this.bizType = json['biz_type'];
    this.version = json['version'];
    this.isShowCancel = json['is_show_cancel'] ?? false;
    this.payload = json['payload'];
    this.key = json['key'];
    this.fromAccount = json['from_account'];
    this.toAccount = json['to_account'];
    this.timestamp = json['timestamp'];
    this.avatar = json['avatar'];
    this.read = json['read'];
    this.uploadProgress = json['upload_progress'] ?? 0;
    this.nickname = json['nickname'];
    this.transferAccount = json['transfer_account'];
  }

  String toBase64() {
    return base64Encode(utf8.encode(json.encode(toJson())));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['biz_type'] = this.bizType;
    data['version'] = this.version;
    data['key'] = this.key;
    data['upload_progress'] = this.uploadProgress;
    data['is_show_cancel'] = this.isShowCancel;
    data['payload'] = this.payload;
    data['from_account'] = this.fromAccount;
    data['to_account'] = this.toAccount;
    data['timestamp'] = this.timestamp;
    data['avatar'] = this.avatar;
    data['read'] = this.read;
    data['nickname'] = this.nickname;
    data['transfer_account'] = this.transferAccount;
    return data;
  }
}
