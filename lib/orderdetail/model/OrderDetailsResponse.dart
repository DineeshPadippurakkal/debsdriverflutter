class OrderDetailResponse { 
  bool? status;
  String? message;
  Data? data;

  OrderDetailResponse({this.status, this.message, this.data});

  OrderDetailResponse.fromJson(Map<String, dynamic> json) {
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
  OrderDetails? orderDetails;
  PickupDetails? pickupDetails;
  DropOffDetails? dropOffDetails;

  Data({this.orderDetails, this.pickupDetails, this.dropOffDetails});

  Data.fromJson(Map<String, dynamic> json) {
    orderDetails = json['order_details'] != null
        ? new OrderDetails.fromJson(json['order_details'])
        : null;
    pickupDetails = json['pickup_details'] != null
        ? new PickupDetails.fromJson(json['pickup_details'])
        : null;
    dropOffDetails = json['drop_off_details'] != null
        ? new DropOffDetails.fromJson(json['drop_off_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails!.toJson();
    }
    if (this.pickupDetails != null) {
      data['pickup_details'] = this.pickupDetails!.toJson();
    }
    if (this.dropOffDetails != null) {
      data['drop_off_details'] = this.dropOffDetails!.toJson();
    }
    return data;
  }
}

class OrderDetails {
  int? id;
  String? referenceId;
  int? taskId;
  String? status;
  String? date;
  String? time;
  String? day;
  bool? isAcknowledged;
  String? paymentType;
  double? paymentAmount;
  double? amountDueOnDelivery;
  bool? needDeliveryProof;
  bool? needSignature;
  List<ItemsDetails>? itemsDetails;
  String? collectionMethod;

  OrderDetails(
      {this.id,
      this.referenceId,
      this.taskId,
      this.status,
      this.date,
      this.time,
      this.day,
      this.isAcknowledged,
      this.paymentType,
      this.paymentAmount,
      this.amountDueOnDelivery,
      this.needDeliveryProof,
      this.needSignature,
      this.itemsDetails,
      this.collectionMethod});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referenceId = json['reference_id'];
    taskId = json['task_id'];
    status = json['status'];
    date = json['date'];
    time = json['time'];
    day = json['day'];
    isAcknowledged = json['is_acknowledged'];
    paymentType = json['payment_type'];
    paymentAmount = json['payment_amount'];
    amountDueOnDelivery = json['amount_due_on_delivery'];
    needDeliveryProof = json['need_delivery_proof'];
    needSignature = json['need_signature'];
    if (json['items_details'] != null) {
      itemsDetails = <ItemsDetails>[];
      json['items_details'].forEach((v) {
        itemsDetails!.add(new ItemsDetails.fromJson(v));
      });
    }
    collectionMethod = json['collection_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reference_id'] = this.referenceId;
    data['task_id'] = this.taskId;
    data['status'] = this.status;
    data['date'] = this.date;
    data['time'] = this.time;
    data['day'] = this.day;
    data['is_acknowledged'] = this.isAcknowledged;
    data['payment_type'] = this.paymentType;
    data['payment_amount'] = this.paymentAmount;
    data['amount_due_on_delivery'] = this.amountDueOnDelivery;
    data['need_delivery_proof'] = this.needDeliveryProof;
    data['need_signature'] = this.needSignature;
    if (this.itemsDetails != null) {
      data['items_details'] =
          this.itemsDetails!.map((v) => v.toJson()).toList();
    }
    data['collection_method'] = this.collectionMethod;
    return data;
  }
}

class ItemsDetails {
  String? name;
  String? description;
  double? price;
  int? quantity;

  ItemsDetails({this.name, this.description, this.price, this.quantity});

  ItemsDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }
}

class PickupDetails {
  String? name;
  String? mobile;
  String? logo;
  double? latitude;
  double? longitude;
  String? state;
  String? area;
  String? block;
  String? building;
  String? street;
  String? pickupPostalCode;
  String? landmark;
  String? houseNumber;
  String? flat;
  String? city;
  String? floor;
  String? notes;
  String? expectedPickupReachTs;

  PickupDetails(
      {this.name,
      this.mobile,
      this.logo,
      this.latitude,
      this.longitude,
      this.state,
      this.area,
      this.block,
      this.building,
      this.street,
      this.pickupPostalCode,
      this.landmark,
      this.houseNumber,
      this.flat,
      this.city,
      this.floor,
      this.notes,
      this.expectedPickupReachTs});

  PickupDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    logo = json['logo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    state = json['state'];
    area = json['area'];
    block = json['block'];
    building = json['building'];
    street = json['street'];
    pickupPostalCode = json['pickup_postal_code'];
    landmark = json['landmark'];
    houseNumber = json['house_number'];
    flat = json['flat'];
    city = json['city'];
    floor = json['floor'];
    notes = json['notes'];
    expectedPickupReachTs = json['expected_pickup_reach_ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['logo'] = this.logo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['state'] = this.state;
    data['area'] = this.area;
    data['block'] = this.block;
    data['building'] = this.building;
    data['street'] = this.street;
    data['pickup_postal_code'] = this.pickupPostalCode;
    data['landmark'] = this.landmark;
    data['house_number'] = this.houseNumber;
    data['flat'] = this.flat;
    data['city'] = this.city;
    data['floor'] = this.floor;
    data['notes'] = this.notes;
    data['expected_pickup_reach_ts'] = this.expectedPickupReachTs;
    return data;
  }
}

class DropOffDetails {
  String? name;
  String? mobile;
  String? area;
  String? block;
  String? city;
  String? landmark;
  String? street;
  String? building;
  String? floor;
  String? flat;
  String? houseNumber;
  String? postalCode;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  double? latitude;
  double? longitude;
  String? notes;
  String? expectedDeliveryTs;

  DropOffDetails(
      {this.name,
      this.mobile,
      this.area,
      this.block,
      this.city,
      this.landmark,
      this.street,
      this.building,
      this.floor,
      this.flat,
      this.houseNumber,
      this.postalCode,
      this.addressLine1,
      this.addressLine2,
      this.addressLine3,
      this.latitude,
      this.longitude,
      this.notes,
      this.expectedDeliveryTs});

  DropOffDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    area = json['area'];
    block = json['block'];
    city = json['city'];
    landmark = json['landmark'];
    street = json['street'];
    building = json['building'];
    floor = json['floor'];
    flat = json['flat'];
    houseNumber = json['house_number'];
    postalCode = json['postal_code'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    addressLine3 = json['address_line3'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    notes = json['notes'];
    expectedDeliveryTs = json['expected_delivery_ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['area'] = this.area;
    data['block'] = this.block;
    data['city'] = this.city;
    data['landmark'] = this.landmark;
    data['street'] = this.street;
    data['building'] = this.building;
    data['floor'] = this.floor;
    data['flat'] = this.flat;
    data['house_number'] = this.houseNumber;
    data['postal_code'] = this.postalCode;
    data['address_line1'] = this.addressLine1;
    data['address_line2'] = this.addressLine2;
    data['address_line3'] = this.addressLine3;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['notes'] = this.notes;
    data['expected_delivery_ts'] = this.expectedDeliveryTs;
    return data;
  }
}