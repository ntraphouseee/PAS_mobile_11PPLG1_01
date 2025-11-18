import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_pas/controller/favorite_controller.dart';

class FavoritePage extends StatelessWidget {
  final FavoriteController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return Center(
            child: Text('No favorite products yet.'),
          );
        }

        return ListView.builder(
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final product = controller.favorites[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.network(
                  product.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(product.title),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeFavorite(product.id),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}