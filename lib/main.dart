import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/api_client.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final loggedIn = GetStorage().read<String>(ApiClient.tokenKey) != null;

  runApp(GetMaterialApp(
    title: 'GetX Employee App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo,
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    ),
    initialBinding: AppBinding(),
    initialRoute: loggedIn ? Routes.home : Routes.login,
    getPages: AppPages.pages,
  ));
}
