class ShiftSummaryResponse {
  bool? status;
  String? message;
  Data? data;

  ShiftSummaryResponse({this.status, this.message, this.data});

  ShiftSummaryResponse.fromJson(Map<String, dynamic> json) {
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
  Summary? summary;
  List<Rows>? rows;

  Data({this.summary, this.rows});

  Data.fromJson(Map<String, dynamic> json) {
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  int? shifts;
  int? orders;
  String? actualWorkingHours;
  String? plannedWorkingHours;
  String? breakHours;

  Summary(
      {this.shifts,
      this.orders,
      this.actualWorkingHours,
      this.plannedWorkingHours,
      this.breakHours});

  Summary.fromJson(Map<String, dynamic> json) {
    shifts = json['shifts'];
    orders = json['orders'];
    actualWorkingHours = json['actual_working_hours'];
    plannedWorkingHours = json['planned_working_hours'];
    breakHours = json['break_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shifts'] = this.shifts;
    data['orders'] = this.orders;
    data['actual_working_hours'] = this.actualWorkingHours;
    data['planned_working_hours'] = this.plannedWorkingHours;
    data['break_hours'] = this.breakHours;
    return data;
  }
}

class Rows {
  String? actualWorkingHours;
  String? breakHours;
  String? plannedWorkingHours;
  int? shifts;
  int? orders;
  String? date;

  Rows(
      {this.actualWorkingHours,
      this.breakHours,
      this.plannedWorkingHours,
      this.shifts,
      this.orders,
      this.date});

  Rows.fromJson(Map<String, dynamic> json) {
    actualWorkingHours = json['actual_working_hours'];
    breakHours = json['break_hours'];
    plannedWorkingHours = json['planned_working_hours'];
    shifts = json['shifts'];
    orders = json['orders'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['actual_working_hours'] = this.actualWorkingHours;
    data['break_hours'] = this.breakHours;
    data['planned_working_hours'] = this.plannedWorkingHours;
    data['shifts'] = this.shifts;
    data['orders'] = this.orders;
    data['date'] = this.date;
    return data;
  }
}