class OrderDetailResponse {
  final bool? status;
  final String? message;
  final OrderData? data;

  OrderDetailResponse({this.status, this.message, this.data});

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

/* ---------------- DATA ---------------- */

class OrderData {
  final OrderDetails? orderDetails;
  final PickupDetails? pickupDetails;
  final DropOffDetails? dropOffDetails;

  OrderData({this.orderDetails, this.pickupDetails, this.dropOffDetails});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderDetails: json['order_details'] != null
          ? OrderDetails.fromJson(json['order_details'])
          : null,
      pickupDetails: json['pickup_details'] != null
          ? PickupDetails.fromJson(json['pickup_details'])
          : null,
      dropOffDetails: json['drop_off_details'] != null
          ? DropOffDetails.fromJson(json['drop_off_details'])
          : null,
    );
  }
}

/* ---------------- ORDER DETAILS ---------------- */

class OrderDetails {
  final int? id;
  final String? referenceId;
  final int? taskId;
  final String? status;
  final String? date;
  final String? time;
  final String? day;
  final bool? isAcknowledged;
  final String? paymentType;
  final double? paymentAmount;
  final double? amountDueOnDelivery;
  final bool? needDeliveryProof;
  final bool? needSignature;
  final String? collectionMethod;

  OrderDetails({
    this.id,
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
    this.collectionMethod,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'],
      referenceId: json['reference_id'],
      taskId: json['task_id'],
      status: json['status'],
      date: json['date'],
      time: json['time'],
      day: json['day'],
      isAcknowledged: json['is_acknowledged'],
      paymentType: json['payment_type'],
      paymentAmount: (json['payment_amount'] as num?)?.toDouble(),
      amountDueOnDelivery:
          (json['amount_due_on_delivery'] as num?)?.toDouble(),
      needDeliveryProof: json['need_delivery_proof'],
      needSignature: json['need_signature'],
      collectionMethod: json['collection_method'],
    );
  }
}

/* ---------------- PICKUP DETAILS ---------------- */

class PickupDetails {
  final String? name;
  final String? mobile;
  final String? logo;
  final double? latitude;
  final double? longitude;
  final String? state;
  final String? area;
  final String? block;
  final String? building;
  final String? street;
  final String? city;
  final String? floor;
  final String? flat;
  final String? houseNumber;
  final String? pickupPostalCode;
  final String? landmark;
  final Instructions? instructions;
  final String? expectedPickupReachTs;

  PickupDetails({
    this.name,
    this.mobile,
    this.logo,
    this.latitude,
    this.longitude,
    this.state,
    this.area,
    this.block,
    this.building,
    this.street,
    this.city,
    this.floor,
    this.flat,
    this.houseNumber,
    this.pickupPostalCode,
    this.landmark,
    this.instructions,
    this.expectedPickupReachTs,
  });

  factory PickupDetails.fromJson(Map<String, dynamic> json) {
    return PickupDetails(
      name: json['name'],
      mobile: json['mobile'],
      logo: json['logo'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      state: json['state'],
      area: json['area'],
      block: json['block'],
      building: json['building'],
      street: json['street'],
      city: json['city'],
      floor: json['floor'],
      flat: json['flat'],
      houseNumber: json['house_number'],
      pickupPostalCode: json['pickup_postal_code'],
      landmark: json['landmark'],
      instructions: json['instructions'] != null
          ? Instructions.fromJson(json['instructions'])
          : null,
      expectedPickupReachTs: json['expected_pickup_reach_ts'],
    );
  }
}

/* ---------------- INSTRUCTIONS ---------------- */

class Instructions {
  final List<dynamic>? attachments;
  final String? notes;

  Instructions({this.attachments, this.notes});

  factory Instructions.fromJson(Map<String, dynamic> json) {
    return Instructions(
      attachments: json['attachments'],
      notes: json['notes'],
    );
  }
}

/* ---------------- DROP OFF DETAILS ---------------- */

class DropOffDetails {
  final String? name;
  final String? mobile;
  final String? area;
  final String? block;
  final String? avenue;
  final String? city;
  final String? landmark;
  final String? street;
  final String? building;
  final String? floor;
  final String? flat;
  final String? houseNumber;
  final String? postalCode;
  final String? addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final String? expectedDeliveryTs;

  DropOffDetails({
    this.name,
    this.mobile,
    this.area,
    this.block,
    this.avenue,
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
    this.expectedDeliveryTs,
  });

  factory DropOffDetails.fromJson(Map<String, dynamic> json) {
    return DropOffDetails(
      name: json['name'],
      mobile: json['mobile'],
      area: json['area'],
      block: json['block'],
      avenue: json['avenue'],
      city: json['city'],
      landmark: json['landmark'],
      street: json['street'],
      building: json['building'],
      floor: json['floor'],
      flat: json['flat'],
      houseNumber: json['house_number'],
      postalCode: json['postal_code'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      addressLine3: json['address_line3'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      notes: json['notes'],
      expectedDeliveryTs: json['expected_delivery_ts'],
    );
  }
}
