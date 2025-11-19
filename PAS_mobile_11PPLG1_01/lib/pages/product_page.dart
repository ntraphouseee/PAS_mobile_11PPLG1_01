import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controller/product_controller.dart';
import '../controller/favorite_controller.dart';
import '../models/product_model.dart';

class ProductPage extends StatelessWidget {
  final ProductController productController = Get.find();
  final FavoriteController favoriteController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (productController.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No products available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => productController.fetchProducts(),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            final product = productController.products[index];
            return _buildProductItem(product);
          },
        );
      }),
    );
  }

  Widget _buildProductItem(Product product) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: product.image ?? '',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 50,
              height: 50,
              color: Colors.grey[200],
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: 50,
              height: 50,
              color: Colors.grey[200],
              child: Icon(Icons.error, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          product.title ?? 'No Title',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
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
                SizedBox(width: 4),
                Text(
                  '(${product.rating?.count ?? 0})',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: Obx(() {
          final isFavorite = favoriteController.isFavorite(product.id ?? 0);
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              if (isFavorite) {
                favoriteController.removeFavorite(product.id ?? 0);
              } else {
                favoriteController.addFavorite(product);
              }
            },
          );
        }),
      ),
    );
  }
}