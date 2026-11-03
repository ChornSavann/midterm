import '../core/api_client.dart';
import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _api;
  ProductRepositoryImpl(this._api);

  @override
  Future<List<Product>> getProducts() async {
    final res = await _api.dio.get('/products', queryParameters: {'limit': 30});
    return (res.data['products'] as List).map((e) => Product.fromJson(e)).toList();
  }
}
