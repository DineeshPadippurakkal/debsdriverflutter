class CODOrdersResponse {
  bool? status;
  String? message;
  List<Data>? data;

  CODOrdersResponse({this.status, this.message, this.data});

  CODOrdersResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? driver;
  int? order;
  double? amount;
  String? orderFrom;
  String? logo;
  String? date;
  String? day;

  Data(
      {this.driver,
      this.order,
      this.amount,
      this.orderFrom,
      this.logo,
      this.date,
      this.day});

  Data.fromJson(Map<String, dynamic> json) {
    driver = json['driver'];
    order = json['order'];
    amount = json['amount'];
    orderFrom = json['order_from'];
    logo = json['logo'];
    date = json['date'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver'] = driver;
    data['order'] = order;
    data['amount'] = amount;
    data['order_from'] = orderFrom;
    data['logo'] = logo;
    data['date'] = date;
    data['day'] = day;
    return data;
  }
}