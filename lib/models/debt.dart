part of 'models.dart';

enum DebtType {
  gave(1),
  splitCost(2);

  final int value;
  const DebtType(this.value);
}

class Debt {
  final int? id;
  final User lender;
  final User debtor;
  final double amount;
  final DebtType type;
  final DateTime date;

  const Debt({
    this.id,
    required this.lender,
    required this.debtor,
    required this.amount,
    required this.type,
    required this.date
  });
}
