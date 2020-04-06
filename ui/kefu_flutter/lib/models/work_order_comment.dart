class WorkOrderCommentModel {
  int id;
  int uid;
  int aid;
  int wid;
  String content;
  String uAvatar;
  String uNickname;
  String aAvatar;
  String aNickname;
  int createAt;

  WorkOrderCommentModel(
      {this.id,
      this.uid,
      this.aid,
      this.wid,
      this.content,
      this.uAvatar,
      this.uNickname,
      this.aAvatar,
      this.aNickname,
      this.createAt});

  WorkOrderCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    aid = json['aid'];
    wid = json['wid'];
    content = json['content'];
    uAvatar = json['u_avatar'];
    uNickname = json['u_nickname'];
    aAvatar = json['a_avatar'];
    aNickname = json['a_nickname'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['aid'] = this.aid;
    data['wid'] = this.wid;
    data['content'] = this.content;
    data['u_avatar'] = this.uAvatar;
    data['u_nickname'] = this.uNickname;
    data['a_avatar'] = this.aAvatar;
    data['a_nickname'] = this.aNickname;
    data['create_at'] = this.createAt;
    return data;
  }
}
