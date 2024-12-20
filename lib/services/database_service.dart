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
    _database = await _DatabaseUtils.initDatabase();
    return _database!;
  }

  Map<dynamic, User>? _users;
  /// Supports users[id] and users[name]
  Future<Map<dynamic, User>> get users async {
    _users ??= await _getUserMap();
    return _users!;
  }

  Map<dynamic, Debt>? _debts;
  /// Supports debts[id], debts[lender], debts[debtor], debts[type], debts[date]
  Future<Map<dynamic, Debt>> get debts async {
    _debts ??= await _getDebtMap();
    return _debts!;
  }

  User? _mainUser;
  Future<User> get mainUser async {
    _mainUser ??= await _getMainUser();
    return _mainUser!;
  }

  Future<Map<dynamic, User>> _getUserMap() async {
    final List<User> users = await _getUsers();
    Map<dynamic, User> userMap = <dynamic, User>{};
    for (User user in users) {
      userMap[user.id!] = user;
      userMap[user.name] = user;
    }
    return userMap;
  }

  Future<Map<dynamic, Debt>> _getDebtMap() async {
    final List<Debt> debts = await _getDebts();
    Map<dynamic, Debt> debtMap = <dynamic, Debt>{};
    for (Debt debt in debts) {
      debtMap[debt.id!] = debt;
      debtMap[debt.lender] = debt;
      debtMap[debt.debtor] = debt;
      debtMap[debt.type] = debt;
      debtMap[debt.date] = debt;
    }
    return debtMap;
  }

  Future<User> _getMainUser() async {
    final Database db = await _instance.database;
    final List<Map<String, dynamic>> dbMainUser = await db.query(
      _TableMainUser.tableName,
      where: '${_TableMainUser.id} = 1'
    );
    final int mainUserId = dbMainUser[0][_TableMainUser.id];
    final Map<dynamic, User> users = await this.users; 
    final User mainUser = users[mainUserId]!;
    return mainUser;
  }

  void _invalidateUserMap() { 
    _users = null; 
  }

  void _invalidateDebtMap() { 
    _debts = null; 
  }

  void _invalidateMainUser() { 
    _mainUser = null; 
  }

  Future<List<User>> _getUsers() async {
    final Database db = await _instance.database;
    final List<Map<String, dynamic>> dbUsers = await db.query(_TableUsers.tableName);
    final List<User> users = List.generate(
      dbUsers.length, 
      (i) => User(
        id:         dbUsers[i][_TableUsers.id], 
        name:       dbUsers[i][_TableUsers.name],
      )
    );
    return users;
  }

  Future<List<Debt>> _getDebts() async {
    final Database db = await _instance.database;
    final List<Map<String, dynamic>> dbDebts = await db.query(_TableDebts.tableName);
    final Map<dynamic, User> users = await this.users;
    final List<Debt> debts = List.generate(
      dbDebts.length, 
      (i) => Debt(
        id:          dbDebts[i][_TableDebts.id],
        lender:      users[dbDebts[i][_TableDebts.lenderId]]!,
        debtor:      users[dbDebts[i][_TableDebts.debtorId]]!,
        amount:      dbDebts[i][_TableDebts.amount],
        type:        DebtType.fromValue(dbDebts[i][_TableDebts.type]),
        description: dbDebts[i][_TableDebts.description],
        date:        DateTime.parse(dbDebts[i][_TableDebts.date])
      )
    );
    return debts;
  }

  Future<void> insertUser(User user) async {
    final Database db = await _instance.database;
    Map<String, dynamic> row = { _TableUsers.name: user.name };
    db.insert(
      _TableUsers.tableName, 
      row,
      conflictAlgorithm: ConflictAlgorithm.abort
    );
    _invalidateUserMap();
  }

  /// Updated by id
  Future<void> updateUser(User user) async {
    assert (user.id != null, 'DatabaseService::updateUser() : User must have a non-null id');
    final Database db = await _instance.database;
    Map<String, dynamic> row = { _TableUsers.name: user.name };
    db.update(
      _TableUsers.tableName, 
      row,
      where: '${_TableUsers.id} = ?',
      whereArgs: [user.id]
    );
    _invalidateUserMap();
    _invalidateMainUser();
  }

  /// Deleted by id
  Future<void> deleteUser(User user) async {
    assert (user.id != (await mainUser).id, 'Cannot delete main user [$user]');
    final Database db = await _instance.database;
    db.delete(
      _TableUsers.tableName, 
      where: '${_TableUsers.id} = ?',
      whereArgs: [user.id]
    );
    _invalidateUserMap();
  }

  Future<void> insertDebt(Debt debt) async {
    assert(debt.lender.id != null, 'DatabaseService::insertDebt() : Lender id must not be null');
    assert(debt.debtor.id != null, 'DatabaseService::insertDebt() : Debtor id must not be null');
    final Database db = await _instance.database;
    Map<String, dynamic> row = {
      _TableDebts.lenderId    : debt.lender.id!,
      _TableDebts.debtorId    : debt.debtor.id!,
      _TableDebts.amount      : debt.amount,
      _TableDebts.type        : debt.type.index,
      _TableDebts.description : debt.description,
      _TableDebts.date        : debt.date.toIso8601String()
    };
    db.insert(
      _TableDebts.tableName, 
      row,
      conflictAlgorithm: ConflictAlgorithm.abort
    );
    _invalidateDebtMap();
  }

  /// Updated by id
  Future<void> updateDebt(Debt debt) async {
    assert (debt.id != null, 'DatabaseService::updateDebt() : Debt must have a non-null id');
    final Database db = await _instance.database;
    Map<String, dynamic> row = {
      _TableDebts.lenderId    : debt.lender.id!,
      _TableDebts.debtorId    : debt.debtor.id!,
      _TableDebts.amount      : debt.amount,
      _TableDebts.type        : debt.type.index,
      _TableDebts.description : debt.description,
      _TableDebts.date        : debt.date.toIso8601String()
    };
    db.update(
      _TableDebts.tableName, 
      row,
      where: '${_TableDebts.id} = ?',
      whereArgs: [debt.id]
    );
    _invalidateDebtMap();
  }

  /// Deleted by id
  Future<void> deleteDebt(Debt debt) async {
    final Database db = await _instance.database;
    db.delete(
      _TableDebts.tableName, 
      where: '${_TableDebts.id} = ?',
      whereArgs: [debt.id]
    );
    _invalidateUserMap();
  }
}

class _DatabaseUtils {
  static final String _dbFileName = 'debt_manager.db';
  static final int    _dbVersion  = 1;

  static Future<Database> initDatabase() async {
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
      'CREATE TABLE ${_TableUsers.tableName}('
      '${_TableUsers.id} INTEGER PRIMARY KEY ASC, '
      '${_TableUsers.name} TEXT UNIQUE NOT NULL'
      ')'
    );
    String tableMainUser = (
      'CREATE TABLE ${_TableMainUser.tableName}('
      '${_TableMainUser.id} INTEGER PRIMARY KEY ASC, '
      '${_TableMainUser.mainUserId} INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE, '
      'CHECK (${_TableMainUser.id} = 1)'
    );
    String tableDebts = (
      'CREATE TABLE ${_TableDebts.tableName}('
      '${_TableDebts.id} INTEGER PRIMARY KEY ASC, '
      '${_TableDebts.lenderId} INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,'
      '${_TableDebts.debtorId} INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE, '
      '${_TableDebts.amount} REAL NOT NULL, '
      '${_TableDebts.type} INTEGER NOT NULL, '
      '${_TableDebts.description} TEXT NOT NULL, '
      '${_TableDebts.date} TEXT NOT NULL, '
      'CHECK (${_TableDebts.lenderId} != ${_TableDebts.debtorId}), '
      'CHECK (${_TableDebts.type} BETWEEN 0 AND ${DebtType.values.length-1})'
      ')'
    );
    
    await db.execute(tableUsers);
    await db.execute(tableMainUser);
    await db.execute(tableDebts);

    db.insert(_TableUsers.tableName, { _TableUsers.name: '%mainUser%' }, conflictAlgorithm: ConflictAlgorithm.abort);
    db.insert(_TableMainUser.tableName, { _TableMainUser.mainUserId: 1 }, conflictAlgorithm: ConflictAlgorithm.abort);
  }
}

class _TableUsers {
  static final String tableName  = 'users';
  static final String id         = 'id';
  static final String name       = 'name';
}

class _TableMainUser {
  static final String tableName  = 'mainUser';
  static final String id         = 'id';
  static final String mainUserId = 'mainUserId';
}

class _TableDebts {
  static final String tableName   = 'debts';
  static final String id          = 'id';
  static final String lenderId    = 'lenderId';
  static final String debtorId    = 'debtorId';
  static final String amount      = 'amount';
  static final String type        = 'type';
  static final String description = 'description';
  static final String date        = 'date';
}
