import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/employee_controller.dart';
import '../controllers/product_controller.dart';
import '../core/api_client.dart';
import '../repositories/auth_repository.dart';
import '../repositories/employee_repository.dart';
import '../repositories/product_repository.dart';
import '../views/home_page.dart';
import '../views/login_page.dart';

class Routes {
  static const login = '/login';
  static const home = '/home';
}

/// Global dependencies: API client, repositories, auth controller.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient(), permanent: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()),
        fenix: true);
    Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(Get.find()),
        fenix: true);
    Get.lazyPut<EmployeeRepository>(() => EmployeeRepositoryImpl(Get.find()),
        fenix: true);
    Get.put(AuthController(Get.find()), permanent: true);
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductController(Get.find()));
    Get.lazyPut(() => EmployeeController(Get.find()));
  }
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.login, page: () => const LoginPage()),
    GetPage(name: Routes.home, page: () => HomePage(), binding: HomeBinding()),
  ];
}
