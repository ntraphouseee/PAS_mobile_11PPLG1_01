import 'package:get/get.dart';
import 'package:latihan_pas/models/product_model.dart';
import 'package:latihan_pas/services/local_db_server.dart';

class FavoriteController extends GetxController {
  var favorites = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Load favorites from local database
  Future<void> loadFavorites() async {
    final data = await LocalDBService.getFavorites();
    favorites.value = data;
  }

  // Add a product to favorites
  Future<void> addFavorite(ProductModel product) async {
    await LocalDBService.addFavorite(product);
    loadFavorites();
  }

  // Remove a product from favorites
  Future<void> removeFavorite(int productId) async {
    await LocalDBService.removeFavorite(productId);
    loadFavorites();
  }
}