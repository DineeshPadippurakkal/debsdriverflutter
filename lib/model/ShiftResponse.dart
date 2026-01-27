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
        slots!.add(Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shift'] = shift;
    data['date'] = date;
    data['day'] = day;
    data['zone'] = zone;
    if (slots != null) {
      data['slots'] = slots!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_active'] = isActive;
    data['slot'] = slot;
    data['is_checkedIn'] = isCheckedIn;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}