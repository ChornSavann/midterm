import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee_controller.dart';
import 'employee_form_page.dart';
import 'widgets.dart';

class EmployeesPage extends GetView<EmployeeController> {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.employees.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.error.value != null && controller.employees.isEmpty) {
        return ErrorView(message: controller.error.value!, onRetry: controller.load);
      }
      if (controller.employees.isEmpty) return const Center(child: Text('No employees yet'));

      return RefreshIndicator(
        onRefresh: controller.load,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 90, top: 8),
          itemCount: controller.employees.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final e = controller.employees[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: e.image.isNotEmpty ? NetworkImage(e.image) : null,
                child: e.image.isEmpty ? Text(e.firstName.isNotEmpty ? e.firstName[0] : '?') : null,
              ),
              title: Text(e.fullName),
              subtitle: Text('${e.position} • ${e.department}\n${e.email}'),
              isThreeLine: true,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => Get.to(() => EmployeeFormPage(employee: e)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => controller.confirmDelete(e),
                ),
              ]),
            );
          },
        ),
      );
    });
  }
}
