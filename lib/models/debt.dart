part of 'models.dart';

enum DebtType {
  gave(0),
  splitCost(1);

  const DebtType(int value);
  factory DebtType.fromValue(int value) {
    if (value == DebtType.gave.index)      return DebtType.gave;
    if (value == DebtType.splitCost.index) return DebtType.splitCost;
    throw AssertionError('DebtType value out of range ($value)');
  }
}

class Debt {
  final int? id;
  final User lender;
  final User debtor;
  final double amount;
  final DebtType type;
  final String description;
  final DateTime date;

  const Debt({
    this.id,
    required this.lender,
    required this.debtor,
    required this.amount,
    required this.type,
    required this.description,
    required this.date
  });
}
