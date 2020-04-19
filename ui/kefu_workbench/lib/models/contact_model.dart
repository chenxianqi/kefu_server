class ContactModel {
  int id;
  int cid;
  int fromAccount;
  int toAccount;
  String lastMessage;
  int isSessionEnd;
  String lastMessageType;
  int uid;
  String avatar;
  String address;
  String nickname;
  String phone;
  int platform;
  int online;
  int read;
  int updateAt;
  String remarks;
  int lastActivity;
  int createAt;
  int contactCreateAt;

  ContactModel(
      {this.id,
      this.cid,
      this.fromAccount,
      this.toAccount,
      this.lastMessage,
      this.isSessionEnd,
      this.lastMessageType,
      this.uid,
      this.avatar,
      this.address,
      this.nickname,
      this.phone,
      this.platform,
      this.online,
      this.read,
      this.updateAt,
      this.remarks,
      this.lastActivity,
      this.createAt,
      this.contactCreateAt});

  ContactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cid = json['cid'];
    fromAccount = json['from_account'];
    toAccount = json['to_account'];
    lastMessage = json['last_message'];
    isSessionEnd = json['is_session_end'];
    lastMessageType = json['last_message_type'];
    uid = json['uid'];
    avatar = json['avatar'];
    address = json['address'];
    nickname = json['nickname'];
    phone = json['phone'];
    platform = json['platform'];
    online = json['online'];
    read = json['read'];
    updateAt = json['update_at'];
    remarks = json['remarks'];
    lastActivity = json['last_activity'];
    createAt = json['create_at'];
    contactCreateAt = json['contact_create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cid'] = this.cid;
    data['from_account'] = this.fromAccount;
    data['to_account'] = this.toAccount;
    data['last_message'] = this.lastMessage;
    data['is_session_end'] = this.isSessionEnd;
    data['last_message_type'] = this.lastMessageType;
    data['uid'] = this.uid;
    data['avatar'] = this.avatar;
    data['address'] = this.address;
    data['nickname'] = this.nickname;
    data['phone'] = this.phone;
    data['platform'] = this.platform;
    data['online'] = this.online;
    data['read'] = this.read;
    data['update_at'] = this.updateAt;
    data['remarks'] = this.remarks;
    data['last_activity'] = this.lastActivity;
    data['create_at'] = this.createAt;
    data['contact_create_at'] = this.contactCreateAt;
    return data;
  }
}