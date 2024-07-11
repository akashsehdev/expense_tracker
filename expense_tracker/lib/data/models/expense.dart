import 'package:flutter/foundation.dart';

class Expense {
  int? id;
  double? amount;
  String? description;
  String? date;
  String? type; // 'income' or 'expense'

  Expense({
    this.id,
    @required this.amount,
    @required this.description,
    @required this.date,
    @required this.type,
  });

  // Convert an Expense into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date,
      'type': type,
    };
  }

  // Extract an Expense object from a Map.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      description: map['description'],
      date: map['date'],
      type: map['type'],
    );
  }
}
