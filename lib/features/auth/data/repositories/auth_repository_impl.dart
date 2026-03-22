import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:stream_xtream/core/network/xtream_data_source.dart';
import 'package:stream_xtream/core/network/local_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final XtreamDataSource _xtreamDataSource;
  final LocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required XtreamDataSource xtreamDataSource,
    required LocalDataSource localDataSource,
  })  : _xtreamDataSource = xtreamDataSource,
        _localDataSource = localDataSource;

  @override
  Future<User> login(String serverUrl, String username, String password) async {
    try {
      final user = await _xtreamDataSource.authenticate(serverUrl, username, password);
      await _localDataSource.saveServerInfo(serverUrl, username, password);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearServerInfo();
  }

  @override
  Future<User?> getCurrentUser() async {
    final serverInfo = await _localDataSource.getServerInfo();
    if (serverInfo == null) return null;

    try {
      final user = await _xtreamDataSource.authenticate(
        serverInfo['serverUrl']!,
        serverInfo['username']!,
        serverInfo['password']!,
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final serverInfo = await _localDataSource.getServerInfo();
    return serverInfo != null;
  }

  @override
  Future<Map<String, String>?> getSavedCredentials() async {
    return _localDataSource.getServerInfo();
  }
}
