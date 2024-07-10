class ExpensesVal {
  final int? id;
  final int userId;
  final double amount;
  final String description;
  final DateTime date;
  final String tag;

  ExpensesVal(
      {this.id,
      required this.userId,
      required this.amount,
      required this.description,
      required this.date,
      required this.tag});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'tag': tag,
    };
  }
}
