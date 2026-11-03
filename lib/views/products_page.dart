import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import 'widgets.dart';

class ProductsPage extends GetView<ProductController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // ពណ៌ផ្ទៃខាងក្រោយទន់ស្រួលមើល
      appBar: AppBar(
        title: const Text(
          'បញ្ជីផលិតផល (Products)',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // អាចបន្ថែមមុខងារស្វែងរកនៅទីនេះ
            },
          ),
        ],
      ),
      body: Obx(() {
        // ពេលកំពុងទាញយកទិន្នន័យដំបូង
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.indigo),
          );
        }

        // ពេលមាន Error
        if (controller.error.value != null && controller.products.isEmpty) {
          return ErrorView(
            message: controller.error.value!,
            onRetry: controller.load,
          );
        }

        // ពេលគ្មានទិន្នន័យផលិតផល
        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'មិនមានទិន្នន័យផលិតផលទេ',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        // បង្ហាញបញ្ជីផលិតផល (Modern List & Card Design)
        return RefreshIndicator(
          color: Colors.indigo,
          onRefresh: controller.load,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.products.length,
            itemBuilder: (_, i) {
              final p = controller.products[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // រូបភាពផលិតផលមានស៊ុមរាងមូលស្អាត
                      Hero(
                        tag: 'product_img_${p.title}_$i',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            p.thumbnail,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.image_not_supported, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // អត្ថបទ និងព័ត៌មានលម្អិត
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ប្រភេទផលិតផល (Category Badge)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                p.category.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // ចំណងជើងផលិតផល
                            Text(
                              p.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // ការពិពណ៌នាខ្លី
                            Text(
                              p.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),

                            // តម្លៃ និង Rating
                            Row(
                              children: [
                                Text(
                                  '\$${p.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.green,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, size: 14, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        p.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}