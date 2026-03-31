import 'package:debs_driver_app/core/domain/value_objects/phone.dart';
import 'package:debs_driver_app/features/order/domain/entities/address.dart';

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

  // mock
  factory OrderDetailResponse.mock() {
    return OrderDetailResponse(
      status: true,
      message: "Order details fetched successfully",
      data: OrderData.mock(),
    );
  }
}

/* ---------------- DATA ---------------- */

final x = {
  "status": true,
  "message": "Success",
  "data": {
    "order_details": {
      "id": 32057,
      "reference_id": null,
      "task_id": 24077,
      "status": "Assigned",
      "date": "2026-03-30",
      "time": "03:07 PM",
      "day": "Monday",
      "is_acknowledged": true,
      "payment_type": "Online",
      "payment_amount": 3333.0,
      "amount_due_on_delivery": 0.0,
      "need_delivery_proof": true,
      "need_signature": true,
      "items_details": [],
      "collection_method": "Collect",
      "order_alerts": []
    },
    "pickup_details": {
      "name": "Culinary Fusion catering company - Hawally",
      "mobile": "99996438",
      "logo":
          "http://staging.allowmena.com/media/supplier/logo/d97177441fff47fdb333b59a628818d1.jpeg",
      "latitude": 29.3456636,
      "longitude": 48.0122536,
      "state": "Hawally",
      "area": "Hawally",
      "block": "Block 1",
      "building": "sondos complex Floor 1 Kitchen 34",
      "street": "Abdullah Al Othman",
      "pickup_postal_code": null,
      "landmark": null,
      "house_number": null,
      "flat": null,
      "city": null,
      "floor": null,
      "instructions": {"attachments": [], "notes": ""},
      "expected_pickup_reach_ts": "2026-03-30 15:25:50"
    },
    "drop_off_details": {}
  }
};

class OrderData {
  final OrderDetails? orderDetails;
  final PickupDetails? pickupDetails;
  final DropOffDetails? dropOffDetails;

  OrderData({this.orderDetails, this.pickupDetails, this.dropOffDetails});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderDetails:
          json['order_details'] != null ? OrderDetails.fromJson(json['order_details']) : null,
      pickupDetails:
          json['pickup_details'] != null ? PickupDetails.fromJson(json['pickup_details']) : null,
      dropOffDetails: json['drop_off_details'] != null
          ? DropOffDetails.fromJson(json['drop_off_details'])
          : null,
    );
  }

  // mock
  factory OrderData.mock() {
    return OrderData(
      orderDetails: OrderDetails.mock(),
      pickupDetails: PickupDetails.mock(),
      dropOffDetails: DropOffDetails.mock(),
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
      amountDueOnDelivery: (json['amount_due_on_delivery'] as num?)?.toDouble(),
      needDeliveryProof: json['need_delivery_proof'],
      needSignature: json['need_signature'],
      collectionMethod: json['collection_method'],
    );
  }

  // mock data
  factory OrderDetails.mock() {
    return OrderDetails(
      id: 1,
      referenceId: "ORD123456",
      taskId: 101,
      status: "Picked Up",
      date: "2024-06-30",
      time: "15:30",
      day: "Monday",
      isAcknowledged: true,
      paymentType: "Prepaid",
      paymentAmount: 49.99,
      amountDueOnDelivery: 0.0,
      needDeliveryProof: true,
      needSignature: true,
      collectionMethod: "Pickup",
    );
  }
}
/* ---------------- COMMON ADDRESS ---------------- */


/* ---------------- PICKUP DETAILS ---------------- */

class PickupDetails {
  final Address address;
  final String? logo;
  final String? state;
  final String? pickupPostalCode;
  final Instructions? instructions;
  final String? expectedPickupReachTs;

  PickupDetails({
    required this.address,
    this.logo,
    this.state,
    this.pickupPostalCode,
    this.instructions,
    this.expectedPickupReachTs,
  });

  // Getters for composition convenience and backward compatibility
  String? get name => address.name;
  Phone? get mobile => address.mobile;
  double? get latitude => address.latitude;
  double? get longitude => address.longitude;
  String? get area => address.area;
  String? get block => address.block;
  String? get building => address.building;
  String? get street => address.street;
  String? get city => address.city;
  String? get floor => address.floor;
  String? get flat => address.flat;
  String? get houseNumber => address.houseNumber;
  String? get landmark => address.landmark;

  factory PickupDetails.fromJson(Map<String, dynamic> json) {
    return PickupDetails(
      address: Address.fromJson(json),
      logo: json['logo'],
      state: json['state'],
      pickupPostalCode: json['pickup_postal_code'],
      instructions:
          json['instructions'] != null ? Instructions.fromJson(json['instructions']) : null,
      expectedPickupReachTs: json['expected_pickup_reach_ts'],
    );
  }

  // mock
  factory PickupDetails.mock() {
    return PickupDetails(
        instructions: Instructions(
          attachments: ["https://example.com/instruction1.png"],
          notes: "Call upon arrival and wait at the lobby.",
        ),
        pickupPostalCode: "94103",
        expectedPickupReachTs: "2024-06-30T17:00:00Z",
        logo: "https://example.com/logo.png",
        state: "California",
        address: Address(
          name: "Alice Smith",
          mobile: Phone.fromString("+14155552671"),
          latitude: 37.7749,
          longitude: -122.4194,
          area: "Financial District",
          block: "A",
          building: "Tech Hub",
          street: "Market Street",
          city: "San Francisco",
          floor: "5",
          flat: "501",
          houseNumber: "456",
          landmark: "Near Ferry Building",
        ));
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
  final Address address;
  final String? avenue;
  final String? postalCode;
  final String? addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String? notes;
  final String? expectedDeliveryTs;

  DropOffDetails({
    required this.address,
    this.avenue,
    this.postalCode,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.notes,
    this.expectedDeliveryTs,
  });

  String? get name => address.name;
  Phone? get mobile => address.mobile;
  double? get latitude => address.latitude;
  double? get longitude => address.longitude;
  String? get area => address.area;
  String? get block => address.block;
  String? get building => address.building;
  String? get street => address.street;
  String? get city => address.city;
  String? get floor => address.floor;
  String? get flat => address.flat;
  String? get houseNumber => address.houseNumber;
  String? get landmark => address.landmark;

  factory DropOffDetails.fromJson(Map<String, dynamic> json) {
    return DropOffDetails(
      address: Address.fromJson(json),
      avenue: json['avenue'],
      postalCode: json['postal_code'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      addressLine3: json['address_line3'],
      notes: json['notes'],
      expectedDeliveryTs: json['expected_delivery_ts'],
    );
  }

  factory DropOffDetails.mock() {
    return DropOffDetails(
        postalCode: "12345",
        addressLine1: "123 Main Street, Sunset Towers, 10th Floor, Flat 1001",
        addressLine2: "Near Central Park, Downtown, Metropolis",
        addressLine3: "",
        notes: "Leave at the front desk if not home.",
        expectedDeliveryTs: "2024-06-30T18:00:00Z",
        avenue: "5th Avenue",
        address: Address(
          name: "John Doe",
          mobile:  Phone.fromString("+14155552672"),
          area: "Downtown",
          block: "B",
          city: "Metropolis",
          landmark: "Near Central Park",
          street: "Main Street",
          building: "Sunset Towers",
          floor: "10",
          flat: "1001",
          houseNumber: "123",
          latitude: 40.7128,
          longitude: -74.0060,
        ));
  }
}
