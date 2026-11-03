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
    middleText: 'Are you sure you want to log out?',
    textConfirm: 'Logout',
    textCancel: 'Cancel',
    confirmTextColor: Colors.white,
    buttonColor: Colors.redAccent,
    onConfirm: () {
      Get.back();
      auth.logout();
    },
  );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text(
          tab.value == 0 ? 'Products Catalog' : 'Employees Management',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header ជាមួយ User Info
            Obx(() {
              final u = auth.user.value;
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: cs.primary),
                accountName: Text(
                  u?.fullName.isNotEmpty == true ? u!.fullName : 'User Name',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                accountEmail: Text(
                  u?.email.isNotEmpty == true ? u!.email : 'user@email.com',
                  style: TextStyle(color: cs.onPrimary.withOpacity(0.8)),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: (u?.image.isNotEmpty ?? false) ? NetworkImage(u!.image) : null,
                  child: (u?.image.isEmpty ?? true)
                      ? Icon(Icons.person, size: 35, color: cs.primary)
                      : null,
                ),
              );
            }),

            // Drawer Menu Items
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Products'),
              selected: tab.value == 0,
              onTap: () {
                tab.value = 0;
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('Employees'),
              selected: tab.value == 1,
              onTap: () {
                tab.value = 1;
                Get.back();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () {
                Get.back();
                _confirmLogout();
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: tab.value,
        children: const [ProductsPage(), EmployeesPage()],
      ),
      floatingActionButton: tab.value == 1
          ? FloatingActionButton.extended(
        onPressed: () => Get.to(() => const EmployeeFormPage()),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Employee'),
      )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab.value,
        onDestinationSelected: (i) => tab.value = i,
        elevation: 3,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Employees',
          ),
        ],
      ),
    ));
  }
}