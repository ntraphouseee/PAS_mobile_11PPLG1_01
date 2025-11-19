import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pas_mobile_11pplg1_01/services/local_db_server.dart';
import '../controller/favorite_controller.dart';
import '../controller/auth_controller.dart';
import '../models/product_model.dart';

class FavoritesPage extends StatelessWidget {
  final FavoriteController favoriteController = Get.find<FavoriteController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print('🔄 Manual refresh triggered');
              print('👤 Current user: ${authController.user.value.username}');
              favoriteController.refreshFavorites();
            },
          ),
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () {
              _debugFavorites();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (favoriteController.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading favorites...'),
                SizedBox(height: 8),
                Text(
                  'User: ${authController.user.value.username ?? "Unknown"}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (favoriteController.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Start adding products to your favorites!',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'User: ${authController.user.value.username ?? "Unknown"}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print('🔄 Debug refresh');
                    print('👤 Current user: ${authController.user.value.username}');
                    favoriteController.refreshFavorites();
                  },
                  child: Text('Debug Refresh'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Header with count and user info
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Favorites',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${favoriteController.favorites.length} items',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'User: ${authController.user.value.username ?? "Unknown"}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Favorites List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: favoriteController.favorites.length,
                itemBuilder: (context, index) {
                  final product = favoriteController.favorites[index];
                  return _buildFavoriteItem(product);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFavoriteItem(Product product) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: product.image ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: Icon(Icons.error, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: 12),
            
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? 'No Title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.category ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        product.rating?.rate?.toStringAsFixed(1) ?? '0.0',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Remove Button
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: () {
                print('🗑️ Removing favorite: ${product.id}');
                favoriteController.removeFavorite(product.id ?? 0);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _debugFavorites() async {
    print('🐛 DEBUG FAVORITES INFO');
    print('👤 Current user: ${authController.user.value.username}');
    print('📊 Local favorites count: ${favoriteController.favorites.length}');
    
    // Debug SharedPreferences
    await LocalDbService.debugAllStorage();
  }
}