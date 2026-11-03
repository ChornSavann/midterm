import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee_controller.dart';
import 'employee_form_page.dart';
import 'widgets.dart';

class EmployeesPage extends GetView<EmployeeController> {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        // ពេលកំពុង Loading ទិន្នន័យដំបូង
        if (controller.isLoading.value && controller.employees.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // ពេលមាន Error
        if (controller.error.value != null && controller.employees.isEmpty) {
          return ErrorView(message: controller.error.value!, onRetry: controller.load);
        }

        // ពេលគ្មានទិន្នន័យបុគ្គលិក
        if (controller.employees.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline_rounded, size: 70, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'No employees yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        // បង្ហាញបញ្ជីបុគ្គលិកក្នុងទម្រង់ Card ស្អាត
        return RefreshIndicator(
          color: cs.primary,
          onRefresh: controller.load,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 90, top: 12, left: 12, right: 12),
            itemCount: controller.employees.length,
            itemBuilder: (_, i) {
              final e = controller.employees[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: ListTile(
                    // រូបភាព Profile Avatar ស្អាត
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: cs.primaryContainer,
                      backgroundImage: e.image.isNotEmpty ? NetworkImage(e.image) : null,
                      child: e.image.isEmpty
                          ? Text(
                        e.firstName.isNotEmpty ? e.firstName[0].toUpperCase() : '?',
                        style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary),
                      )
                          : null,
                    ),
                    // ឈ្មោះបុគ្គលិក
                    title: Text(
                      e.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                    // ព័ត៌មានលម្អិត តួនាទី និងអ៊ីមែល (កែសម្រួល string formatting មិនឱ្យ Error)
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '${e.position} • ${e.department}\n${e.email}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.3),
                      ),
                    ),
                    isThreeLine: true,
                    // ប៊ូតុង Edit និង Delete
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_outlined, color: cs.primary),
                          onPressed: () => Get.to(() => EmployeeFormPage(employee: e)),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => controller.confirmDelete(e),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
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