import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class LocalDbService {
  static const String _tokenKey = 'user_token';
  static const String _userKey = 'user_data';
  static const String _usernameKey = 'current_username'; // KEY BARU

  // Favorites key berdasarkan username yang PERSISTENT
  static String _getFavoritesKey(String? username) {
    if (username == null || username.isEmpty) {
      print('🔴 WARNING: Creating favorites key with null username');
      return 'favorites_unknown';
    }
    return 'favorites_$username';
  }

  // Token Management
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // User Management
  static Future<void> saveUser(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userData);
    
    // SIMPAN JUGA USERNAME SECARA TERPISAH
    try {
      final userMap = json.decode(userData);
      final username = userMap['username'];
      if (username != null) {
        await prefs.setString(_usernameKey, username);
        print('💾 Saved persistent username: $username');
      }
    } catch (e) {
      print('🔴 Error saving username: $e');
    }
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  // GET PERSISTENT USERNAME (tidak tergantung user_data)
  static Future<String?> getPersistentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // Favorites Management - PER USER
  static Future<void> addFavorite(Product product, String username) async {
    try {
      if (username.isEmpty) {
        print('🔴 Cannot add favorite: Empty username');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites(username);
      
      // Check if product already exists
      if (!favorites.any((p) => p.id == product.id)) {
        favorites.add(product);
        final favoritesKey = _getFavoritesKey(username);
        
        // Convert ke JSON
        final favoritesJsonList = favorites.map((p) => p.toJson()).toList();
        final favoritesJson = json.encode(favoritesJsonList);
        
        // Save ke SharedPreferences
        final success = await prefs.setString(favoritesKey, favoritesJson);
        
        print('💾 Saved favorite for $username: ${product.title}');
        print('💾 Save result: $success for key: $favoritesKey');
        print('📊 Total favorites: ${favorites.length}');
        
      } else {
        print('ℹ️ Product already in favorites: ${product.title}');
      }
    } catch (e) {
      print('🔴 Error in addFavorite: $e');
    }
  }

  static Future<void> removeFavorite(int productId, String username) async {
    try {
      if (username.isEmpty) {
        print('🔴 Cannot remove favorite: Empty username');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites(username);
      
      final initialCount = favorites.length;
      favorites.removeWhere((product) => product.id == productId);
      
      if (favorites.length < initialCount) {
        final favoritesKey = _getFavoritesKey(username);
        final favoritesJsonList = favorites.map((p) => p.toJson()).toList();
        final favoritesJson = json.encode(favoritesJsonList);
        
        await prefs.setString(favoritesKey, favoritesJson);
        print('💾 Removed favorite: $productId');
        print('📊 Total favorites: ${favorites.length}');
      } else {
        print('ℹ️ Product not found in favorites: $productId');
      }
    } catch (e) {
      print('🔴 Error in removeFavorite: $e');
    }
  }

  static Future<List<Product>> getFavorites(String? username) async {
    try {
      if (username == null || username.isEmpty) {
        print('🔴 Cannot get favorites: Invalid username');
        return [];
      }

      final prefs = await SharedPreferences.getInstance();
      final favoritesKey = _getFavoritesKey(username);
      
      print('🔍 Getting favorites for key: $favoritesKey');
      
      final favoritesJson = prefs.getString(favoritesKey);
      
      if (favoritesJson != null && favoritesJson.isNotEmpty) {
        final List<dynamic> data = json.decode(favoritesJson);
        final favorites = data.map((json) => Product.fromJson(json)).toList();
        
        print('✅ Successfully loaded ${favorites.length} favorites for $username');
        return favorites;
      } else {
        print('📭 No favorites found for $username');
        return [];
      }
    } catch (e) {
      print('🔴 Error in getFavorites: $e');
      return [];
    }
  }

  // Clear auth data saja (favorites tetap tersimpan)
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    // JANGAN hapus _usernameKey agar favorites tetap bisa diakses
    print('🔐 Cleared auth data (username preserved for favorites)');
  }

  // Clear semua data (termasuk favorites)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('🗑️ Cleared ALL SharedPreferences data');
  }

  // Debug semua data di SharedPreferences
  static Future<void> debugAllStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().toList()..sort();
    
    print('=' * 50);
    print('🔍 DEBUG SHAREDPREFERENCES STORAGE');
    print('=' * 50);
    
    for (String key in keys) {
      final value = prefs.get(key);
      if (key.startsWith('favorites_')) {
        print('⭐ FAVORITES KEY: $key');
        if (value is String) {
          try {
            final data = json.decode(value) as List;
            print('   📦 Items: ${data.length}');
            for (int i = 0; i < data.length; i++) {
              final item = data[i];
              print('   ${i + 1}. ID: ${item['id']}, Title: ${item['title']}');
            }
          } catch (e) {
            print('   🔴 Error parsing: $e');
          }
        }
      } else if (key == _usernameKey) {
        print('👤 PERSISTENT USERNAME: $value');
      } else {
        print('📝 $key: $value');
      }
    }
    print('=' * 50);
  }
}