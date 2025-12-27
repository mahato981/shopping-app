import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shopping.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE products (
        id $idType,
        name $textType,
        description $textType,
        price $realType,
        originalPrice $realType,
        imageUrl $textType,
        category $textType,
        rating $realType,
        reviewCount $intType
      )
    ''');

    print('Database created successfully!');
  }

  // Insert a product
  Future<Product> insertProduct(Product product) async {
    final db = await instance.database;
    final id = await db.insert('products', product.toMap());
    return product.copyWith(id: id);
  }

  // Insert multiple products
  Future<void> insertProducts(List<Product> products) async {
    final db = await instance.database;
    final batch = db.batch();

    for (var product in products) {
      batch.insert('products', product.toMap());
    }

    await batch.commit(noResult: true);
    print('${products.length} products inserted successfully!');
  }

  // Get all products
  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    const orderBy = 'id ASC';
    final result = await db.query('products', orderBy: orderBy);

    return result.map((json) => Product.fromMap(json)).toList();
  }

  // Get product by ID
  Future<Product?> getProductById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Search products by name or category
  Future<List<Product>> searchProducts(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'products',
      where: 'name LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return result.map((json) => Product.fromMap(json)).toList();
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );

    return result.map((json) => Product.fromMap(json)).toList();
  }

  // Get all categories
  Future<List<String>> getAllCategories() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT DISTINCT category FROM products');
    
    return result.map((row) => row['category'] as String).toList();
  }

  // Update a product
  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Delete a product
  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all products
  Future<int> deleteAllProducts() async {
    final db = await instance.database;
    return await db.delete('products');
  }

  // Get product count
  Future<int> getProductCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM products');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Close database
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
