class OrderHistoryRes {
  bool? status;
  List<Data>? data;
  String? message;
  Links? links;
  int? count;

  OrderHistoryRes(
      {this.status, this.data, this.message, this.links, this.count});

  OrderHistoryRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    data['count'] = this.count;
    return data;
  }
}

class Data {
  int? order;
  int? driver;
  String? date;
  String? time;
  String? day;
  int? supplierBranch;
  String? orderFrom;
  Location? location;
  int? orderStatus;
  String? orderStatusLabel;
  String? logo;
  String? areaName;
  bool? isAcknowledged;
  String? paymentTypeLabel; 
  double? paymentAmount;
  int? task;
  int? priority;
  String? referenceId;
  String? pickupAreaName;

  Data(
      {this.order,
      this.driver,
      this.date,
      this.time,
      this.day,
      this.supplierBranch,
      this.orderFrom,
      this.location,
      this.orderStatus,
      this.orderStatusLabel,
      this.logo,
      this.areaName,
      this.isAcknowledged,
      this.paymentTypeLabel, 
      this.paymentAmount,
      this.task,
      this.priority,
      this.referenceId,
      this.pickupAreaName});

  Data.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    driver = json['driver'];
    date = json['date'];
    time = json['time'];
    day = json['day'];
    supplierBranch = json['supplier_branch'];
    orderFrom = json['order_from'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    orderStatus = json['order_status'];
    orderStatusLabel = json['order_status_label'];
    logo = json['logo'];
    areaName = json['area_name'];
    isAcknowledged = json['is_acknowledged'];
    paymentTypeLabel = json['payment_type_label'];
    paymentTypeLabel = json['payment_type__label'];
    paymentAmount = json['payment_amount'];
    task = json['task'];
    priority = json['priority'];
    referenceId = json['reference_id'];
    pickupAreaName = json['pickup_area_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = this.order;
    data['driver'] = this.driver;
    data['date'] = this.date;
    data['time'] = this.time;
    data['day'] = this.day;
    data['supplier_branch'] = this.supplierBranch;
    data['order_from'] = this.orderFrom;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['order_status'] = this.orderStatus;
    data['order_status_label'] = this.orderStatusLabel;
    data['logo'] = this.logo;
    data['area_name'] = this.areaName;
    data['is_acknowledged'] = this.isAcknowledged;
    data['payment_type_label'] = this.paymentTypeLabel;
    data['payment_type__label'] = this.paymentTypeLabel;
    data['payment_amount'] = this.paymentAmount;
    data['task'] = this.task;
    data['priority'] = this.priority;
    data['reference_id'] = this.referenceId;
    data['pickup_area_name'] = this.pickupAreaName;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class Links {
  String? next;
  String? previous;
  int? offset;
  int? limit;

  Links({this.next, this.previous, this.offset, this.limit});

  Links.fromJson(Map<String, dynamic> json) {
    next = json['next'];
    previous = json['previous'];
    offset = json['offset'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next'] = this.next;
    data['previous'] = this.previous;
    data['offset'] = this.offset;
    data['limit'] = this.limit;
    return data;
  }
}