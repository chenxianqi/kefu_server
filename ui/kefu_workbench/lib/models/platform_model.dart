class PlatformModel {
  int id;
  String title;
  String alias;
  int system;

  PlatformModel({this.id, this.title, this.alias, this.system});

  PlatformModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    alias = json['alias'];
    system = json['system'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['alias'] = this.alias;
    data['system'] = this.system;
    return data;
  }
}