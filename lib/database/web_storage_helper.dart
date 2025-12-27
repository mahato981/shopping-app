import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WebStorageHelper {
  static const String _productsKey = 'cached_products';
  static const String _categoriesKey = 'cached_categories';

  // Save products to localStorage
  static Future<void> saveProducts(List<Product> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = products.map((p) => p.toMap()).toList();
      final jsonString = json.encode(jsonList);
      await prefs.setString(_productsKey, jsonString);
      print('✅ Saved ${products.length} products to web storage');
    } catch (e) {
      print('❌ Error saving products: $e');
    }
  }

  // Load products from localStorage
  static Future<List<Product>> loadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_productsKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        print('ℹ️ No cached products found');
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      final products = jsonList.map((json) => Product.fromMap(json)).toList();
      print('✅ Loaded ${products.length} products from web storage');
      return products;
    } catch (e) {
      print('❌ Error loading products: $e');
      return [];
    }
  }

  // Save categories to localStorage
  static Future<void> saveCategories(List<String> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_categoriesKey, categories);
      print('✅ Saved ${categories.length} categories to web storage');
    } catch (e) {
      print('❌ Error saving categories: $e');
    }
  }

  // Load categories from localStorage
  static Future<List<String>> loadCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categories = prefs.getStringList(_categoriesKey) ?? [];
      print('✅ Loaded ${categories.length} categories from web storage');
      return categories;
    } catch (e) {
      print('❌ Error loading categories: $e');
      return [];
    }
  }

  // Clear all cached data
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_productsKey);
      await prefs.remove(_categoriesKey);
      print('✅ Cleared web storage cache');
    } catch (e) {
      print('❌ Error clearing cache: $e');
    }
  }

  // Get product count
  static Future<int> getProductCount() async {
    final products = await loadProducts();
    return products.length;
  }

  // Search products
  static Future<List<Product>> searchProducts(String query) async {
    final products = await loadProducts();
    return products
        .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get products by category
  static Future<List<Product>> getProductsByCategory(String category) async {
    final products = await loadProducts();
    return products.where((p) => p.category == category).toList();
  }
}
