import 'package:get/get.dart';
import 'package:pas_mobile_11pplg1_01/models/product_model.dart';
import 'package:pas_mobile_11pplg1_01/services/api_service.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      final data = await ApiService.getProducts();
      products.value = data.map((json) => Product.fromJson(json)).toList();
      filteredProducts.value = products;
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products.where((product) {
        return product.title!.toLowerCase().contains(query.toLowerCase()) ||
               product.category!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}