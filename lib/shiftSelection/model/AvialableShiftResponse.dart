class AvialableShiftResponse {
  bool? status;
  String? message;
  List<Data>? data;

  AvialableShiftResponse({this.status, this.message, this.data});

  AvialableShiftResponse.fromJson(Map<String, dynamic> json) {
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
  int? weekSchedule;
  String? year;
  String? startDate;
  String? endDate;
  String? zoneName;
  bool? isOffDateSelected;

  Data(
      {this.weekSchedule,
      this.year,
      this.startDate,
      this.endDate,
      this.zoneName,
      this.isOffDateSelected});

  Data.fromJson(Map<String, dynamic> json) {
    weekSchedule = json['week_schedule'];
    year = json['year'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    zoneName = json['zone_name'];
    isOffDateSelected = json['is_off_date_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['week_schedule'] = this.weekSchedule;
    data['year'] = this.year;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['zone_name'] = this.zoneName;
    data['is_off_date_selected'] = this.isOffDateSelected;
    return data;
  }
}