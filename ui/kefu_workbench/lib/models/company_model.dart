class CompanyModel {
  int id;
  String title;
  String logo;
  String service;
  String email;
  String tel;
  String address;
  int updateAt;

  CompanyModel(
      {this.id,
      this.title,
      this.logo,
      this.service,
      this.email,
      this.tel,
      this.address,
      this.updateAt});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    logo = json['logo'];
    service = json['service'];
    email = json['email'];
    tel = json['tel'];
    address = json['address'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['logo'] = this.logo;
    data['service'] = this.service;
    data['email'] = this.email;
    data['tel'] = this.tel;
    data['address'] = this.address;
    data['update_at'] = this.updateAt;
    return data;
  }
}