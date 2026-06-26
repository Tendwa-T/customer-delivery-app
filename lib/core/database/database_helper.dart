import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;
  static const String dbName = 'delivery_app.db';
  static const int dbVersion = 1;

  static const String _createDeliveriesTable = '''
		CREATE TABLE delivery_requests (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			pickup_address TEXT NOT NULL,
			delivery_address TEXT NOT NULL,
			package_name TEXT NOT NULL,
			package_code TEXT NOT NULL UNIQUE,
			package_description TEXT ,
			package_weight TEXT NOT NULL CHECK (package_weight > 0),
			package_weight_unit TEXT NOT NULL,
			status TEXT NOT NULL DEFAULT 'pending',
			created_at TEXT NOT NULL,
		)
	''';

  static const String _createStatusIndex = '''
		CREATE INDEX idx_delivery_status on delivery_requests (status)
	''';

  static const String _createCodeIndex = '''
		CREATE INDEX idx_code on delivery_requests (package_code)
	''';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createDeliveriesTable);
    await db.execute(_createStatusIndex);
    await db.execute(_createCodeIndex);
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  Future<void> deleteDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
