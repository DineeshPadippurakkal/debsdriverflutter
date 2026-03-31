import 'package:debs_driver_app/core/domain/value_objects/phone.dart';

class Address {
  final String? name;
  final Phone? mobile;
  final double? latitude;
  final double? longitude;
  final String? area;
  final String? block;
  final String? building;
  final String? street;
  final String? city;
  final String? floor;
  final String? flat;
  final String? houseNumber;
  final String? landmark;

  Address({
    this.name,
    this.mobile,
    this.latitude,
    this.longitude,
    this.area,
    this.block,
    this.building,
    this.street,
    this.city,
    this.floor,
    this.flat,
    this.houseNumber,
    this.landmark,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name'],
      mobile:json['mobile'] ==null ?null: Phone.fromString(json['mobile']),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      area: json['area'],
      block: json['block'],
      building: json['building'],
      street: json['street'],
      city: json['city'],
      floor: json['floor'],
      flat: json['flat'],
      houseNumber: json['house_number'],
      landmark: json['landmark'],
    );
  }
}
