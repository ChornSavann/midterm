import 'package:get/get.dart';
import '../core/api_client.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _repo;
  ProductController(this._repo);

  final products = <Product>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      products.assignAll(await _repo.getProducts());
    } catch (e) {
      error.value = ApiClient.message(e);
    } finally {
      isLoading.value = false;
    }
  }
}
