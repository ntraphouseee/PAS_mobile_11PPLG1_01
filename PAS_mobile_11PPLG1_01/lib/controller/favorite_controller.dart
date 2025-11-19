import 'package:get/get.dart';
import 'package:pas_mobile_11pplg1_01/models/product_model.dart';
import 'package:pas_mobile_11pplg1_01/services/local_db_server.dart';
import 'package:pas_mobile_11pplg1_01/controller/auth_controller.dart';

class FavoriteController extends GetxController {
  var favorites = <Product>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('🟡 FavoriteController initialized');
    
    // Initial load
    _initialLoad();
  }

  void _initialLoad() async {
    // Tunggu sebentar untuk pastikan AuthController ready
    await Future.delayed(Duration(milliseconds: 1500));
    
    // COBA DUA CARA: dari AuthController DAN dari Persistent Storage
    String? username;
    
    // Cara 1: Dari AuthController
    final authController = Get.find<AuthController>();
    if (authController.isLoggedIn.value && authController.currentUsername != null) {
      username = authController.currentUsername;
      print('👤 Using username from AuthController: $username');
    }
    
    // Cara 2: Dari Persistent Storage (fallback)
    if (username == null) {
      username = await LocalDbService.getPersistentUsername();
      print('👤 Using username from Persistent Storage: $username');
    }
    
    if (username != null) {
      await loadFavorites(username);
    } else {
      print('🔴 Cannot load favorites: No username available');
    }
  }

  Future<void> loadFavorites(String username) async {
    isLoading.value = true;
    try {
      print('🟡 Loading favorites for user: $username');
      
      final favoriteProducts = await LocalDbService.getFavorites(username);
      favorites.assignAll(favoriteProducts);
      
      print('🟢 Loaded ${favorites.length} favorites for user: $username');
      
    } catch (e) {
      print('🔴 Error loading favorites: $e');
      favorites.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFavorite(Product product) async {
    try {
      // GUNAKAN PERSISTENT USERNAME sebagai fallback
      String? username = Get.find<AuthController>().currentUsername;
      if (username == null) {
        username = await LocalDbService.getPersistentUsername();
      }
      
      if (username == null) {
        print('🔴 Cannot add favorite: No user logged in');
        return;
      }
      
      print('❤️ Adding favorite: ${product.title} for user: $username');
      await LocalDbService.addFavorite(product, username);
      
      // Update local state
      if (!favorites.any((p) => p.id == product.id)) {
        favorites.add(product);
        print('🟢 Added to local favorites: ${product.title}');
      }
      
    } catch (e) {
      print('🔴 Error adding favorite: $e');
    }
  }

  Future<void> removeFavorite(int productId) async {
    try {
      String? username = Get.find<AuthController>().currentUsername;
      if (username == null) {
        username = await LocalDbService.getPersistentUsername();
      }
      
      if (username == null) {
        print('🔴 Cannot remove favorite: No user logged in');
        return;
      }
      
      await LocalDbService.removeFavorite(productId, username);
      favorites.removeWhere((product) => product.id == productId);
      print('🟢 Removed favorite: $productId');
    } catch (e) {
      print('🔴 Error removing favorite: $e');
    }
  }

  bool isFavorite(int productId) {
    return favorites.any((product) => product.id == productId);
  }

  Future<void> refreshFavorites() async {
    print('🔄 Manual refresh favorites');
    
    String? username = Get.find<AuthController>().currentUsername;
    if (username == null) {
      username = await LocalDbService.getPersistentUsername();
    }
    
    if (username != null) {
      await loadFavorites(username);
    }
  }

  void clearLocalFavorites() {
    favorites.clear();
    print('🟢 Cleared local favorites cache');
  }

  int get favoritesCount => favorites.length;
}