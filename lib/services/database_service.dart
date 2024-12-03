import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  DatabaseService._internal();
  factory DatabaseService() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _DatabaseUtils.initDatabase();
    return _database!;
  }
}

class _DatabaseUtils {
  static Future<Database> initDatabase() async {
    String dbDir = await getDatabasesPath();
    String dbPath = join(dbDir, 'debt_manager.db');
    Database db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreateDatabase,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
    return db;
  }

  static Future<void> _onCreateDatabase(Database db, int version) async {
    
    String tableUsers = (
      'CREATE TABLE users('
      'id INTEGER PRIMARY KEY ASC, '
      'name TEXT, '
      'phone TEXT'
      ')'
    );

    String tableDebts = (
      'CREATE TABLE debts('
      'id INTEGER PRIMARY KEY ASC, '
      'lenderId INTEGER, '
      'debtorId INTEGER, '
      'amount REAL, '
      'type INTEGER, '
      'date INTEGER, '
      'FOREIGN KEY(lenderId) REFERENCES users(id), '
      'FOREIGN KEY(debtorId) REFERENCES users(id)'
      ')'
    );

    await db.execute('');
  }
}
