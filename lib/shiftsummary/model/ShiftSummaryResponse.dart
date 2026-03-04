class ShiftSummaryResponse {
  bool? status;
  String? message;
  Data? data;

  ShiftSummaryResponse({this.status, this.message, this.data});

  ShiftSummaryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (rows != null) {
      data['rows'] = rows!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shifts'] = shifts;
    data['orders'] = orders;
    data['actual_working_hours'] = actualWorkingHours;
    data['planned_working_hours'] = plannedWorkingHours;
    data['break_hours'] = breakHours;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actual_working_hours'] = actualWorkingHours;
    data['break_hours'] = breakHours;
    data['planned_working_hours'] = plannedWorkingHours;
    data['shifts'] = shifts;
    data['orders'] = orders;
    data['date'] = date;
    return data;
  }
}