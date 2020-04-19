class WorkOrderModel {
  int id;
  int uid;
  int tid;
  String title;
  String content;
  String phone;
  String email;
  int status;
  int lastReply;
  int cid;
  int closeAt;
  String remark;
  int updateAt;
  int delete;
  int createAt;
  String uNickname;
  String uAvatar;
  String aNickname;

  WorkOrderModel(
      {this.id,
      this.uid,
      this.tid,
      this.title,
      this.content,
      this.phone,
      this.email,
      this.status,
      this.lastReply,
      this.cid,
      this.closeAt,
      this.remark,
      this.updateAt,
      this.delete,
      this.createAt,
      this.uNickname,
      this.uAvatar,
      this.aNickname});

  WorkOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    tid = json['tid'];
    title = json['title'];
    content = json['content'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
    lastReply = json['last_reply'];
    cid = json['cid'];
    closeAt = json['close_at'];
    remark = json['remark'];
    updateAt = json['update_at'];
    delete = json['delete'];
    createAt = json['create_at'];
    uNickname = json['u_nickname'];
    uAvatar = json['u_avatar'];
    aNickname = json['a_nickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['tid'] = this.tid;
    data['title'] = this.title;
    data['content'] = this.content;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['status'] = this.status;
    data['last_reply'] = this.lastReply;
    data['cid'] = this.cid;
    data['close_at'] = this.closeAt;
    data['remark'] = this.remark;
    data['update_at'] = this.updateAt;
    data['delete'] = this.delete;
    data['create_at'] = this.createAt;
    data['u_nickname'] = this.uNickname;
    data['u_avatar'] = this.uAvatar;
    data['a_nickname'] = this.aNickname;
    return data;
  }
}