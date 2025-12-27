import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/product.dart';
import '../database/database_helper.dart';
import '../database/web_storage_helper.dart';

/// Unified storage service that uses SQLite on mobile/desktop and SharedPreferences on web
class StorageService {
  static final StorageService instance = StorageService._init();
  
  StorageService._init();

  // Check if running on web
  bool get isWeb => kIsWeb;

  /// Save multiple products
  Future<void> saveProducts(List<Product> products) async {
    if (isWeb) {
      // Use SharedPreferences for web
      await WebStorageHelper.saveProducts(products);
      
      // Extract and save categories
      final categories = products.map((p) => p.category).toSet().toList();
      await WebStorageHelper.saveCategories(categories);
      
      print('💾 [WEB] Saved ${products.length} products to localStorage');
    } else {
      // Use SQLite for mobile/desktop
      await DatabaseHelper.instance.insertProducts(products);
      print('💾 [MOBILE/DESKTOP] Saved ${products.length} products to SQLite');
    }
  }

  /// Get all products
  Future<List<Product>> getAllProducts() async {
    if (isWeb) {
      final products = await WebStorageHelper.loadProducts();
      print('📦 [WEB] Loaded ${products.length} products from localStorage');
      return products;
    } else {
      final products = await DatabaseHelper.instance.getAllProducts();
      print('📦 [MOBILE/DESKTOP] Loaded ${products.length} products from SQLite');
      return products;
    }
  }

  /// Get all categories
  Future<List<String>> getAllCategories() async {
    if (isWeb) {
      final categories = await WebStorageHelper.loadCategories();
      print('🏷️ [WEB] Loaded ${categories.length} categories from localStorage');
      return categories;
    } else {
      final categories = await DatabaseHelper.instance.getAllCategories();
      print('🏷️ [MOBILE/DESKTOP] Loaded ${categories.length} categories from SQLite');
      return categories;
    }
  }

  /// Get product count
  Future<int> getProductCount() async {
    if (isWeb) {
      return await WebStorageHelper.getProductCount();
    } else {
      return await DatabaseHelper.instance.getProductCount();
    }
  }

  /// Get product by ID
  Future<Product?> getProductById(int id) async {
    if (isWeb) {
      final products = await WebStorageHelper.loadProducts();
      try {
        return products.firstWhere((p) => p.id == id);
      } catch (e) {
        return null;
      }
    } else {
      return await DatabaseHelper.instance.getProductById(id);
    }
  }

  /// Search products by name or category
  Future<List<Product>> searchProducts(String query) async {
    if (isWeb) {
      return await WebStorageHelper.searchProducts(query);
    } else {
      return await DatabaseHelper.instance.searchProducts(query);
    }
  }

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    if (isWeb) {
      return await WebStorageHelper.getProductsByCategory(category);
    } else {
      return await DatabaseHelper.instance.getProductsByCategory(category);
    }
  }

  /// Delete all products (clear cache)
  Future<void> clearAllProducts() async {
    if (isWeb) {
      await WebStorageHelper.clearCache();
      print('🗑️ [WEB] Cleared all products from localStorage');
    } else {
      await DatabaseHelper.instance.deleteAllProducts();
      print('🗑️ [MOBILE/DESKTOP] Cleared all products from SQLite');
    }
  }

  /// Insert a single product
  Future<Product> insertProduct(Product product) async {
    if (isWeb) {
      // For web, we need to load all products, add the new one, and save back
      final products = await WebStorageHelper.loadProducts();
      final newId = products.isEmpty ? 1 : products.map((p) => p.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      final newProduct = product.copyWith(id: newId);
      products.add(newProduct);
      await WebStorageHelper.saveProducts(products);
      print('➕ [WEB] Inserted product: ${newProduct.name}');
      return newProduct;
    } else {
      final result = await DatabaseHelper.instance.insertProduct(product);
      print('➕ [MOBILE/DESKTOP] Inserted product: ${result.name}');
      return result;
    }
  }

  /// Update a product
  Future<int> updateProduct(Product product) async {
    if (isWeb) {
      final products = await WebStorageHelper.loadProducts();
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
        await WebStorageHelper.saveProducts(products);
        print('✏️ [WEB] Updated product: ${product.name}');
        return 1;
      }
      return 0;
    } else {
      final result = await DatabaseHelper.instance.updateProduct(product);
      print('✏️ [MOBILE/DESKTOP] Updated product: ${product.name}');
      return result;
    }
  }

  /// Delete a product
  Future<int> deleteProduct(int id) async {
    if (isWeb) {
      final products = await WebStorageHelper.loadProducts();
      final initialLength = products.length;
      products.removeWhere((p) => p.id == id);
      await WebStorageHelper.saveProducts(products);
      final deleted = initialLength - products.length;
      print('🗑️ [WEB] Deleted product with id: $id');
      return deleted;
    } else {
      final result = await DatabaseHelper.instance.deleteProduct(id);
      print('🗑️ [MOBILE/DESKTOP] Deleted product with id: $id');
      return result;
    }
  }

  /// Get storage type info (for debugging)
  String get storageType => isWeb ? 'Web (localStorage)' : 'Native (SQLite)';
}
