class GetAllShiftDayResponse {
  bool? status;
  String? message;
  Data? data;

  GetAllShiftDayResponse({this.status, this.message, this.data});

  GetAllShiftDayResponse.fromJson(Map<String, dynamic> json) {
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
  List<Days>? days;
  bool? isCompleted;

  Data({this.days, this.isCompleted});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(new Days.fromJson(v));
      });
    }
    isCompleted = json['is_completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.days != null) {
      data['days'] = this.days!.map((v) => v.toJson()).toList();
    }
    data['is_completed'] = this.isCompleted;
    return data;
  }
}

class Days {
  final String date;
  final String day;
  final bool isActive;
  final List<String> selectedShift;
  final List<Shifts>? shifts;

  Days({
    required this.date,
    required this.day,
    required this.isActive,
    required this.selectedShift,
    this.shifts,
  });

  factory Days.fromJson(Map<String, dynamic> json) {
    return Days(
      date: json['date'],
      day: json['day'],
      isActive: json['is_active'],
      selectedShift: List<String>.from(json['selected_shift'] ?? []),
      shifts: json['shifts'] != null
          ? (json['shifts'] as List)
              .map((e) => Shifts.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    data['is_active'] = this.isActive;
    if (this.shifts != null) {
      data['shifts'] = this.shifts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shifts {
  int? shift;
  List<String>? time;

  Shifts({this.shift, this.time});

  Shifts.fromJson(Map<String, dynamic> json) {
    shift = json['shift'];
    time = json['time'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shift'] = this.shift;
    data['time'] = this.time;
    return data;
  }
}