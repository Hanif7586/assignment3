import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('weather.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE weather(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        temperature REAL
      )
    ''');
  }

  // Method to save weather data
  Future<void> saveWeather(String name, double temperature) async {
    final db = await database;
    await db.insert('weather', {
      'name': name,
      'temperature': temperature,
    });
  }

  // Method to fetch saved weather data
  Future<List<Map<String, dynamic>>> getSavedWeather() async {
    final db = await database;
    return await db.query('weather');
  }
}
