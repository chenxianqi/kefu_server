class FlowModel {
  String count;
  String platform;
  String title;

  FlowModel({this.count, this.platform, this.title});

  FlowModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    platform = json['platform'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['platform'] = this.platform;
    data['title'] = this.title;
    return data;
  }
}