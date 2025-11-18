import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_pas/controller/product_controller.dart';
import 'package:latihan_pas/controller/favorite_controller.dart';

class ProductPage extends StatelessWidget {
  final ProductController productController = Get.find();
  final FavoriteController favoriteController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Obx(() {
        if (productController.products.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            final product = productController.products[index];
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
                  icon: Icon(Icons.bookmark),
                  onPressed: () => favoriteController.addFavorite(product),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}