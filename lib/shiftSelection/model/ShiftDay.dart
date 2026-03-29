import 'package:debs_driver_app/shiftSelection/model/Shift.dart';

class  Shiftday {

  final String date;
  final String day;
  final bool isActive;
  final List<String> selectedShift;
  final List<Shift>? shifts;

  Shiftday({
    required this.date,
    required this.day,
    required this.isActive,
    required this.selectedShift,
    this.shifts,
  });

  factory Shiftday.fromJson(Map<String, dynamic> json) {
    return Shiftday(
      date: json['date'],
      day: json['day'],
      isActive: json['is_active'],
      selectedShift: List<String>.from(json['selected_shift'] ?? []),
      shifts: json['shifts'] != null
          ? (json['shifts'] as List)
              .map((e) => Shift.fromJson(e))
              .toList()
          : null,
    );
  }
}
 