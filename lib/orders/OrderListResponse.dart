class OrderListResponse {
  bool? status;
  String? message;
  Data? data;

  OrderListResponse({this.status, this.message, this.data});

  OrderListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
        tasks!.add(Tasks.fromJson(v));
      });
    }
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions!.add(Actions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tasks != null) {
      data['tasks'] = tasks!.map((v) => v.toJson()).toList();
    }
    if (actions != null) {
      data['actions'] = actions!.map((v) => v.toJson()).toList();
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
        ? PickupDetails.fromJson(json['pickup_details'])
        : null;
    isActive = json['is_active'];
    isAcknowledged = json['is_acknowledged'];
    isMultiple = json['is_multiple'];
    taskId = json['task_id'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pickupDetails != null) {
      data['pickup_details'] = pickupDetails!.toJson();
    }
    data['is_active'] = isActive;
    data['is_acknowledged'] = isAcknowledged;
    data['is_multiple'] = isMultiple;
    data['task_id'] = taskId;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['area'] = area;
    data['name'] = name;
    data['mobile'] = mobile;
    data['logo'] = logo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
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
  String? collectionMethod;
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
      this.collectionMethod,
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
    collectionMethod=json['collection_method'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reference_id'] = referenceId;
    data['date'] = date;
    data['time'] = time;
    data['day'] = day;
    data['priority'] = priority;
    data['area'] = area;
    data['amount'] = amount;
    data['is_active'] = isActive;
     data['collection_method'] = collectionMethod;
    data['id'] = id;
    data['status'] = status;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task_id'] = taskId;
    data['action_id'] = actionId;
    data['action_label'] = actionLabel;
    data['order_id'] = orderId;
    return data;
  }
}
