class WorkOrderCountsModel {
  int status0;
  int status1;
  int status2;
  int status3;
  int deleteCount;

  WorkOrderCountsModel(
      {this.status0,
      this.status1,
      this.status2,
      this.status3,
      this.deleteCount});

  WorkOrderCountsModel.fromJson(Map<String, dynamic> json) {
    status0 = json['status0'];
    status1 = json['status1'];
    status2 = json['status2'];
    status3 = json['status3'];
    deleteCount = json['delete_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status0'] = this.status0;
    data['status1'] = this.status1;
    data['status2'] = this.status2;
    data['status3'] = this.status3;
    data['delete_count'] = this.deleteCount;
    return data;
  }
}