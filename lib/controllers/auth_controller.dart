import 'package:flutter/material.dart' show EdgeInsets;
import 'package:get/get.dart';
import '../core/api_client.dart';
import '../models/user_profile.dart';
import '../repositories/auth_repository.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthRepository _repo;
  AuthController(this._repo);

  final user = Rxn<UserProfile>();
  final isLoading = false.obs;
  final obscure = true.obs;

  @override
  void onInit() {
    user.value = _repo.cachedUser();
    super.onInit();
  }

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    try {
      user.value = await _repo.login(username, password);
      Get.offAllNamed(Routes.home);
    } catch (e) {
      Get.snackbar('Login failed', ApiClient.message(e),
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    user.value = null;
    Get.offAllNamed(Routes.login);
  }
}
