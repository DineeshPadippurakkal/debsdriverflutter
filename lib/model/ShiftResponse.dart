class ShiftListResponse {
  bool? status;
  String? message;
  List<Data>? data;

  ShiftListResponse({this.status, this.message, this.data});

  ShiftListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? shift;
  String? date;
  String? day;
  String? zone;
  List<Slots>? slots;

  Data({this.shift, this.date, this.day, this.zone, this.slots});

  Data.fromJson(Map<String, dynamic> json) {
    shift = json['shift'];
    date = json['date'];
    day = json['day'];
    zone = json['zone'];
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shift'] = this.shift;
    data['date'] = this.date;
    data['day'] = this.day;
    data['zone'] = this.zone;
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  bool? isActive;
  int? slot;
  bool? isCheckedIn;
  String? startTime;
  String? endTime;

  Slots(
      {this.isActive,
      this.slot,
      this.isCheckedIn,
      this.startTime,
      this.endTime});

  Slots.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    slot = json['slot'];
    isCheckedIn = json['is_checkedIn'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_active'] = this.isActive;
    data['slot'] = this.slot;
    data['is_checkedIn'] = this.isCheckedIn;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}