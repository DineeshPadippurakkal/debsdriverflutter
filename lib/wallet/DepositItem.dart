class DepositItem {
  final int id;
  final double amount;
  final String day;
  final String date;
  final String createdAt;
  final String user;

  DepositItem({
    required this.id,
    required this.amount,
    required this.day,
    required this.date,
    required this.createdAt,
    required this.user,
  });

  factory DepositItem.fromJson(Map<String, dynamic> json) {
    return DepositItem(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      day: json['day'],
      date: json['date'],
      createdAt: json['created_at'],
      user: json['user'],
    );
  }
}
