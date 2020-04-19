class SystemInfoModel {
  int id;
  String title;
  String logo;
  String copyRight;
  int uploadMode;
  int updateAt;

  SystemInfoModel(
      {this.id,
      this.title,
      this.logo,
      this.copyRight,
      this.uploadMode,
      this.updateAt});

  SystemInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    logo = json['logo'];
    copyRight = json['copy_right'];
    uploadMode = json['upload_mode'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['logo'] = this.logo;
    data['copy_right'] = this.copyRight;
    data['upload_mode'] = this.uploadMode;
    data['update_at'] = this.updateAt;
    return data;
  }
}