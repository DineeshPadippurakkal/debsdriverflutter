class SubmitShiftResponse {
  final bool status;
  final String message;
  final SubmitShiftData data;

  SubmitShiftResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubmitShiftResponse.fromJson(Map<String, dynamic> json) {
    return SubmitShiftResponse(
      status: json['status'],
      message: json['message'],
      data: SubmitShiftData.fromJson(json['data']),
    );
  }
}

class SubmitShiftData {
  final String day;
  final String date;
  final List<SubmitShift> shift;

  SubmitShiftData({
    required this.day,
    required this.date,
    required this.shift,
  });

  factory SubmitShiftData.fromJson(Map<String, dynamic> json) {
    return SubmitShiftData(
      day: json['day'],
      date: json['date'],
      shift: (json['shift'] as List)
          .map((e) => SubmitShift.fromJson(e))
          .toList(),
    );
  }
}


class SubmitShift {
  final int shift;
  final List<String> time;

  SubmitShift({
    required this.shift,
    required this.time,
  });

  factory SubmitShift.fromJson(Map<String, dynamic> json) {
    return SubmitShift(
      shift: json['shift'],
      time: List<String>.from(json['time']),
    );
  }
}