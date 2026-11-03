import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

/// Single Dio instance. Attaches the JWT to every request and
/// forces logout when the server answers 401 (token expired/invalid).
class ApiClient {
  static const baseUrl = 'https://dummyjson.com';
  static const tokenKey = 'access_token';
  static const userKey = 'user';

  final GetStorage box = GetStorage();
  late final Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final t = token;
        if (t != null) options.headers['Authorization'] = 'Bearer $t';
        handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401 && e.requestOptions.path != '/auth/login') {
          clearSession();
          Get.offAllNamed('/login');
        }
        handler.next(e);
      },
    ));
  }

  String? get token => box.read<String>(tokenKey);
  Future<void> saveToken(String t) => box.write(tokenKey, t);
  Future<void> clearSession() async {
    await box.remove(tokenKey);
    await box.remove(userKey);
  }

  /// Converts any exception into a readable message.
  static String message(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'].toString();
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return 'Connection timed out. Please try again.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        default:
          return 'Server error (${e.response?.statusCode ?? 'unknown'}).';
      }
    }
    return 'Something went wrong.';
  }
}
