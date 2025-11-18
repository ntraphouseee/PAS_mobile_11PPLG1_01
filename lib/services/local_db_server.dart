import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:latihan_pas/models/product_model.dart';

class LocalDBService {
  static Database? _database;

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY,
            title TEXT,
            price REAL,
            description TEXT,
            category TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<void> addFavorite(ProductModel product) async {
    final db = await database;
    await db.insert(
      'favorites',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<ProductModel>> getFavorites() async {
    final db = await database;
    final result = await db.query('favorites');
    return result.map((data) => ProductModel.fromMap(data)).toList();
  }

  static Future<void> removeFavorite(int productId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [productId],
    );
  }
}