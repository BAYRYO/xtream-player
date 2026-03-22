import 'package:hive/hive.dart';
import 'package:stream_xtream/core/constants/app_constants.dart';
import 'package:stream_xtream/features/profile/data/models/profile_model.dart';

abstract class LocalDataSource {
  Future<void> saveServerInfo(String serverUrl, String username, String password);
  Future<Map<String, String>?> getServerInfo();
  Future<void> clearServerInfo();
  Future<void> saveProfiles(List<ProfileModel> profiles);
  Future<List<ProfileModel>> getProfiles();
  Future<void> saveActiveProfile(String profileId);
  Future<String?> getActiveProfileId();
  Future<void> saveWatchProgress(String key, Map<String, dynamic> progress);
  Future<Map<String, dynamic>?> getWatchProgress(String key);
  Future<void> clearWatchProgress(String key);
  Future<List<Map<String, dynamic>>> getAllWatchProgress(String profileId);
  Future<void> clearAllWatchProgress(String profileId);
}

class LocalDataSourceImpl implements LocalDataSource {
  final Box<String> _settingsBox;
  final Box<ProfileModel> _profilesBox;
  final Box<Map> _watchProgressBox;

  LocalDataSourceImpl({
    required Box<String> settingsBox,
    required Box<ProfileModel> profilesBox,
    required Box<Map> watchProgressBox,
  })  : _settingsBox = settingsBox,
        _profilesBox = profilesBox,
        _watchProgressBox = watchProgressBox;

  @override
  Future<void> saveServerInfo(String serverUrl, String username, String password) async {
    await _settingsBox.put(AppConstants.serverUrlKey, serverUrl);
    await _settingsBox.put(AppConstants.usernameKey, username);
    await _settingsBox.put(AppConstants.passwordKey, password);
  }

  @override
  Future<Map<String, String>?> getServerInfo() async {
    final serverUrl = _settingsBox.get(AppConstants.serverUrlKey);
    final username = _settingsBox.get(AppConstants.usernameKey);
    final password = _settingsBox.get(AppConstants.passwordKey);

    if (serverUrl == null || username == null) return null;

    return {
      'serverUrl': serverUrl,
      'username': username,
      'password': password ?? '',
    };
  }

  @override
  Future<void> clearServerInfo() async {
    await _settingsBox.delete(AppConstants.serverUrlKey);
    await _settingsBox.delete(AppConstants.usernameKey);
    await _settingsBox.delete(AppConstants.passwordKey);
    await _settingsBox.delete(AppConstants.authTokenKey);
    await _settingsBox.delete(AppConstants.userDataKey);
  }

  @override
  Future<void> saveProfiles(List<ProfileModel> profiles) async {
    await _profilesBox.clear();
    for (final profile in profiles) {
      await _profilesBox.put(profile.id, profile);
    }
  }

  @override
  Future<List<ProfileModel>> getProfiles() async {
    return _profilesBox.values.toList();
  }

  @override
  Future<void> saveActiveProfile(String profileId) async {
    await _settingsBox.put(AppConstants.activeProfileKey, profileId);
  }

  @override
  Future<String?> getActiveProfileId() async {
    return _settingsBox.get(AppConstants.activeProfileKey);
  }

  @override
  Future<void> saveWatchProgress(String key, Map<String, dynamic> progress) async {
    await _watchProgressBox.put(key, progress);
  }

  @override
  Future<Map<String, dynamic>?> getWatchProgress(String key) async {
    final data = _watchProgressBox.get(key);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  @override
  Future<void> clearWatchProgress(String key) async {
    await _watchProgressBox.delete(key);
  }

  @override
  Future<List<Map<String, dynamic>>> getAllWatchProgress(String profileId) async {
    return _watchProgressBox.values
        .where((progress) => progress['profileId'] == profileId)
        .map((progress) => Map<String, dynamic>.from(progress))
        .toList();
  }

  @override
  Future<void> clearAllWatchProgress(String profileId) async {
    final keysToDelete = <String>[];
    for (final key in _watchProgressBox.keys) {
      final progress = _watchProgressBox.get(key);
      if (progress != null && progress['profileId'] == profileId) {
        keysToDelete.add(key as String);
      }
    }
    await _watchProgressBox.deleteAll(keysToDelete);
  }
}
