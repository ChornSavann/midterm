import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'employee_form_page.dart';
import 'employees_page.dart';
import 'products_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final tab = 0.obs;
  final auth = Get.find<AuthController>();

  void _confirmLogout() => Get.defaultDialog(
        title: 'Logout',
        middleText: 'Do you want to log out?',
        textConfirm: 'Logout',
        textCancel: 'Cancel',
        onConfirm: () {
          Get.back();
          auth.logout();
        },
      );

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(tab.value == 0 ? 'Products' : 'Employees'),
            actions: [IconButton(icon: const Icon(Icons.logout), tooltip: 'Logout', onPressed: _confirmLogout)],
          ),
          drawer: Drawer(
            child: SafeArea(
              child: Column(children: [
                Obx(() {
                  final u = auth.user.value;
                  return UserAccountsDrawerHeader(
                    accountName: Text(u?.fullName ?? ''),
                    accountEmail: Text(u?.email ?? ''),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: (u?.image.isNotEmpty ?? false) ? NetworkImage(u!.image) : null,
                      child: (u?.image.isEmpty ?? true) ? const Icon(Icons.person) : null,
                    ),
                  );
                }),
                ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: _confirmLogout),
              ]),
            ),
          ),
          body: IndexedStack(index: tab.value, children: const [ProductsPage(), EmployeesPage()]),
          floatingActionButton: tab.value == 1
              ? FloatingActionButton.extended(
                  onPressed: () => Get.to(() => const EmployeeFormPage()),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add'),
                )
              : null,
          bottomNavigationBar: NavigationBar(
            selectedIndex: tab.value,
            onDestinationSelected: (i) => tab.value = i,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag), label: 'Products'),
              NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Employees'),
            ],
          ),
        ));
  }
}
