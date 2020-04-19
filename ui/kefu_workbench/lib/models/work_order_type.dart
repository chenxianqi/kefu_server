class WorkOrderTypeModel {
  int id;
  String title;
  int createAt;
  int count;

  WorkOrderTypeModel({this.id, this.title, this.createAt, this.count});

  WorkOrderTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    count = json['count'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['count'] = this.count;
    data['create_at'] = this.createAt;
    return data;
  }
}
