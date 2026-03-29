class Shift {
  final int shift;
  final List<String> time;

  Shift({
    required this.shift,
    required this.time,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      shift: json['shift'],
      time: List<String>.from(json['time']),
    );
  }
}