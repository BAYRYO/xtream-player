import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String serverUrl, String username, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<Map<String, String>?> getSavedCredentials();
}
