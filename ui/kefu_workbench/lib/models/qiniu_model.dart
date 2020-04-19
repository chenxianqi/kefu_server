class QiniuModel {
  int id;
  String bucket;
  String accessKey;
  String secretKey;
  String host;
  int updateAt;

  QiniuModel(
      {this.id,
      this.bucket,
      this.accessKey,
      this.secretKey,
      this.host,
      this.updateAt});

  QiniuModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bucket = json['bucket'];
    accessKey = json['access_key'];
    secretKey = json['secret_key'];
    host = json['host'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bucket'] = this.bucket;
    data['access_key'] = this.accessKey;
    data['secret_key'] = this.secretKey;
    data['host'] = this.host;
    data['update_at'] = this.updateAt;
    return data;
  }
}