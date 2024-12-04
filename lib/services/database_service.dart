import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:debt_manager_lite/models/models.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  DatabaseService._internal();
  factory DatabaseService() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _DatabaseUtils._initDatabase();
    return _database!;
  }

  Future<void> insertUser(User user) async {
    final Database db = await _instance.database;
    Map<String, dynamic> row = {'name': user.name};
    db.insert(
      'users', 
      row,
      conflictAlgorithm: ConflictAlgorithm.abort
    );
  }

  Future<void> insertDebt(Debt debt) async {
    assert(debt.lender.id != null, 'Lender id must not be null');
    assert(debt.debtor.id != null, 'Debtor id must not be null');

    final Database db = await _instance.database;
    Map<String, dynamic> row = {'lenderId': debt.lender.id!,
                                'debtorId': debt.debtor.id!,
                                'amount'  : debt.amount,
                                'type'    : debt.type.value,
                                'date'    : debt.date};
    
    db.insert(
      'users', 
      row,
      conflictAlgorithm: ConflictAlgorithm.abort
    );
  }


}

class _DatabaseUtils {
  static final String _dbFileName = 'debt_manager.db';
  static final int    _dbVersion  = 1;

  static final _DatabaseSchema _dbSchema = _DatabaseSchema();

  static Future<Database> _initDatabase() async {
    String dbDir = await getDatabasesPath();
    String dbPath = join(dbDir, _dbFileName);
    Database db = await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreateDatabase,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
    return db;
  }

  static Future<void> _onCreateDatabase(Database db, int version) async {
    
    String tableUsers = (
      'CREATE TABLE users('
      'id INTEGER PRIMARY KEY ASC, '
      'name TEXT UNIQUE, '
      ')'
    );

    String tableDebts = (
      'CREATE TABLE debts('
      'id INTEGER PRIMARY KEY ASC, '
      'lenderId INTEGER REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,'
      'debtorId INTEGER REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE, '
      'amount REAL, '
      'type INTEGER, '
      'date TEXT'
      ')'
    );

    await db.execute(tableUsers);
    await db.execute(tableDebts);
  }
}

class _DatabaseSchema {
  final _Tables tables = _Tables();
}

class _Tables {
  final _TableUsers users = _TableUsers();
  final _TableDebts debts = _TableDebts();
}

class _TableUsers {
  final String name = 'users';
  final _TableUsersColumns columns = _TableUsersColumns();
}

class _TableUsersColumns {
  final String id   = 'id';
  final String name = 'name';
}

class _TableDebts {
  final String name = 'debts';
  final _TableDebtsColumns columns = _TableDebtsColumns();
}

class _TableDebtsColumns {
  final String id       = 'id';
  final String lenderId = 'lenderId';
  final String debtorId = 'debtorId';
  final String amount   = 'amount';
  final String type     = 'type';
  final String date     = 'date';
}
