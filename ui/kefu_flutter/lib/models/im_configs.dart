class ImConfigs {
  int uploadMode;
  String uploadSecret;
  String uploadHost;
  int openWorkorder;

  ImConfigs(
      {this.uploadMode,
      this.uploadSecret,
      this.uploadHost,
      this.openWorkorder});

  ImConfigs.fromJson(Map<String, dynamic> json) {
    uploadMode = json['upload_mode'];
    uploadSecret = json['upload_secret'];
    uploadHost = json['upload_host'];
    openWorkorder = json['open_workorder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['upload_mode'] = this.uploadMode;
    data['upload_secret'] = this.uploadSecret;
    data['upload_host'] = this.uploadHost;
    data['open_workorder'] = this.openWorkorder;
    return data;
  }
}