class ProfileDetailsResponse {
  bool? status;
  String? message;
  ProfileData? data;

  ProfileDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ProfileDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? ProfileData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

// ------------------------------------------------------------------

class ProfileData {
  String? firstName;
  String? lastName;
  String? email;
  int? role;
  int? preferredLanguage;
  String? address;
  String? mobile;
  int? id;
  String? roleName;
  int? supplierId;
  List<String>? slugs;
  int? userType;
  int? roleId;
  bool? isSuperUser;
  String? userTypeSlug;
  Country? country;

  ProfileData({
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.preferredLanguage,
    this.address,
    this.mobile,
    this.id,
    this.roleName,
    this.supplierId,
    this.slugs,
    this.userType,
    this.roleId,
    this.isSuperUser,
    this.userTypeSlug,
    this.country,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      role: json['role'],
      preferredLanguage: json['preferred_language'],
      address: json['address'],
      mobile: json['mobile'],
      id: json['id'],
      roleName: json['role_name'],
      supplierId: json['supplier_id'],
      slugs: json['slugs'] != null
          ? List<String>.from(json['slugs'])
          : [],
      userType: json['user_type'],
      roleId: json['role_id'],
      isSuperUser: json['is_super_user'],
      userTypeSlug: json['user_type_slug'],
      country: json['country'] != null
          ? Country.fromJson(json['country'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'role': role,
      'preferred_language': preferredLanguage,
      'address': address,
      'mobile': mobile,
      'id': id,
      'role_name': roleName,
      'supplier_id': supplierId,
      'slugs': slugs,
      'user_type': userType,
      'role_id': roleId,
      'is_super_user': isSuperUser,
      'user_type_slug': userTypeSlug,
      'country': country?.toJson(),
    };
  }
}

// ------------------------------------------------------------------

class Country {
  String? name;
  int? code;
  String? isoCode;
  int? mobNumDigits;
  String? nationalIdDataType;
  int? nationalIdDataSize;
  int? id;
  List<StateModel>? states;
  CenterLocation? center;
  double? westLongitude;
  double? southLatitude;
  double? eastLongitude;
  double? northLatitude;

  Country({
    this.name,
    this.code,
    this.isoCode,
    this.mobNumDigits,
    this.nationalIdDataType,
    this.nationalIdDataSize,
    this.id,
    this.states,
    this.center,
    this.westLongitude,
    this.southLatitude,
    this.eastLongitude,
    this.northLatitude,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      isoCode: json['iso_code'],
      mobNumDigits: json['mob_num_digits'],
      nationalIdDataType: json['national_id_data_type'],
      nationalIdDataSize: json['national_id_data_size'],
      id: json['id'],
      states: json['states'] != null
          ? (json['states'] as List)
              .map((e) => StateModel.fromJson(e))
              .toList()
          : [],
      center: json['center'] != null
          ? CenterLocation.fromJson(json['center'])
          : null,
      westLongitude: (json['west_longitude'] as num?)?.toDouble(),
      southLatitude: (json['south_latitude'] as num?)?.toDouble(),
      eastLongitude: (json['east_longitude'] as num?)?.toDouble(),
      northLatitude: (json['north_latitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'iso_code': isoCode,
      'mob_num_digits': mobNumDigits,
      'national_id_data_type': nationalIdDataType,
      'national_id_data_size': nationalIdDataSize,
      'id': id,
      'states': states?.map((e) => e.toJson()).toList(),
      'center': center?.toJson(),
      'west_longitude': westLongitude,
      'south_latitude': southLatitude,
      'east_longitude': eastLongitude,
      'north_latitude': northLatitude,
    };
  }
}

// ------------------------------------------------------------------

class StateModel {
  String? name;
  int? country;
  int? id;

  StateModel({
    this.name,
    this.country,
    this.id,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      name: json['name'],
      country: json['country'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'id': id,
    };
  }
}

// ------------------------------------------------------------------

class CenterLocation {
  double? lat;
  double? long;

  CenterLocation({
    this.lat,
    this.long,
  });

  factory CenterLocation.fromJson(Map<String, dynamic> json) {
    return CenterLocation(
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
    };
  }
}
