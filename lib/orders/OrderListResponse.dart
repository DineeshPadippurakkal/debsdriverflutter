class OrderListResponse {
  bool? status;
  String? message;
  Data? data;

  OrderListResponse({this.status, this.message, this.data});

  OrderListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Tasks>? tasks;
  List<Actions>? actions;

  Data({this.tasks, this.actions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new Tasks.fromJson(v));
      });
    }
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions!.add(new Actions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    if (this.actions != null) {
      data['actions'] = this.actions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasks {
  PickupDetails? pickupDetails;
  bool? isActive;
  bool? isAcknowledged;
  bool? isMultiple;
  int? taskId;
  List<Orders>? orders;

  Tasks(
      {this.pickupDetails,
      this.isActive,
      this.isAcknowledged,
      this.isMultiple,
      this.taskId,
      this.orders});

  Tasks.fromJson(Map<String, dynamic> json) {
    pickupDetails = json['pickup_details'] != null
        ? new PickupDetails.fromJson(json['pickup_details'])
        : null;
    isActive = json['is_active'];
    isAcknowledged = json['is_acknowledged'];
    isMultiple = json['is_multiple'];
    taskId = json['task_id'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pickupDetails != null) {
      data['pickup_details'] = this.pickupDetails!.toJson();
    }
    data['is_active'] = this.isActive;
    data['is_acknowledged'] = this.isAcknowledged;
    data['is_multiple'] = this.isMultiple;
    data['task_id'] = this.taskId;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PickupDetails {
  String? area;
  String? name;
  String? mobile;
  String? logo;
  double? latitude;
  double? longitude;

  PickupDetails(
      {this.area,
      this.name,
      this.mobile,
      this.logo,
      this.latitude,
      this.longitude});

  PickupDetails.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    name = json['name'];
    mobile = json['mobile'];
    logo = json['logo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['logo'] = this.logo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Orders {
  String? referenceId;
  String? date;
  String? time;
  String? day;
  int? priority;
  String? area;
  double? amount;
  bool? isActive;
  int? id;
  String? status;

  Orders(
      {this.referenceId,
      this.date,
      this.time,
      this.day,
      this.priority,
      this.area,
      this.amount,
      this.isActive,
      this.id,
      this.status});

  Orders.fromJson(Map<String, dynamic> json) {
    referenceId = json['reference_id'];
    date = json['date'];
    time = json['time'];
    day = json['day'];
    priority = json['priority'];
    area = json['area'];
    amount = json['amount'];
    isActive = json['is_active'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reference_id'] = this.referenceId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['day'] = this.day;
    data['priority'] = this.priority;
    data['area'] = this.area;
    data['amount'] = this.amount;
    data['is_active'] = this.isActive;
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}

class Actions {
  int? taskId;
  int? actionId;
  String? actionLabel;
  int? orderId;

  Actions({this.taskId, this.actionId, this.actionLabel, this.orderId});

  Actions.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    actionId = json['action_id'];
    actionLabel = json['action_label'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskId;
    data['action_id'] = this.actionId;
    data['action_label'] = this.actionLabel;
    data['order_id'] = this.orderId;
    return data;
  }
}
