import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import 'widgets.dart';

class ProductsPage extends GetView<ProductController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.products.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.error.value != null && controller.products.isEmpty) {
        return ErrorView(message: controller.error.value!, onRetry: controller.load);
      }
      return RefreshIndicator(
        onRefresh: controller.load,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.products.length,
          itemBuilder: (_, i) {
            final p = controller.products[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(p.thumbnail, width: 80, height: 80, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(width: 80, height: 80, child: Icon(Icons.image_not_supported))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(p.category, style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(children: [
                        Text('\$${p.price.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                        const Spacer(),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(p.rating.toStringAsFixed(1)),
                      ]),
                    ]),
                  ),
                ]),
              ),
            );
          },
        ),
      );
    });
  }
}
