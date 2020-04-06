class WorkOrderTypeModel {
  int id;
  String title;
  int createAt;

  WorkOrderTypeModel({this.id, this.title, this.createAt});

  WorkOrderTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['create_at'] = this.createAt;
    return data;
  }
}
