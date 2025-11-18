import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductListPage extends StatelessWidget {
  final RxList products = [].obs;

  @override
  Widget build(BuildContext context) {
    _fetchProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Obx(() {
        if (products.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              child: ListTile(
                title: Text(product['title']),
                subtitle: Text('\$${product['price']}'),
                trailing: IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                    // Save to local DB
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      products.value = json.decode(response.body);
    }
  }
}
