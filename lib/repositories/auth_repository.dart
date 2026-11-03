import '../core/api_client.dart';
import '../models/user_profile.dart';

abstract class AuthRepository {
  Future<UserProfile> login(String username, String password);
  UserProfile? cachedUser();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _api;
  AuthRepositoryImpl(this._api);

  @override
  Future<UserProfile> login(String username, String password) async {
    final res = await _api.dio.post('/auth/login',
        data: {'username': username, 'password': password, 'expiresInMins': 60});
    await _api.saveToken(res.data['accessToken']); // JWT
    final user = UserProfile.fromJson(res.data);
    await _api.box.write(ApiClient.userKey, user.toJson());
    return user;
  }

  @override
  UserProfile? cachedUser() {
    final m = _api.box.read(ApiClient.userKey);
    return m == null ? null : UserProfile.fromJson(Map<String, dynamic>.from(m));
  }

  @override
  Future<void> logout() => _api.clearSession();
}
