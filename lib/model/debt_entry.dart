/*enum DebtEntryType {
  gave(1),
  splitCost(2)

  final int id;

  const DebtEntryType(this.id);
}

class DebtEntry {
  final int id
  final String lender;
  final String debtor;
  final double amount;
  final DebtEntryType type;
  final DateTime date;

  const DebtEntry({
    required this.lender,
    required this.debtor,
    required this.amount,
    required this.type,
    required this.date
  });
}*/

/*
TABLE debts
  INT id PK
  INT lenderId FK (people)
  INT debtorId FK (people)
  REAL amount
  INT type [1, 2]
  INT date

TABLE people
  INT id PK
  STRING name
  STRING phone
*/

