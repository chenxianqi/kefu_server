class StatisticalCountModel {
  String date;
  List<StatisticalItems> statisticalItems;

  StatisticalCountModel({this.date, this.statisticalItems});

  StatisticalCountModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['list'] != null) {
      statisticalItems = new List<StatisticalItems>();
      json['list'].forEach((v) {
        statisticalItems.add(new StatisticalItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.statisticalItems != null) {
      data['list'] =
          this.statisticalItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatisticalItems {
  String count;
  String id;
  String title;

  StatisticalItems({this.count, this.id, this.title});

  StatisticalItems.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}