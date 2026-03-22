import 'package:stream_xtream/features/profile/domain/entities/profile.dart';
import 'package:stream_xtream/features/profile/domain/repositories/profile_repository.dart';
import 'package:stream_xtream/core/network/local_data_source.dart';
import 'package:stream_xtream/features/profile/data/models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final LocalDataSource _localDataSource;

  ProfileRepositoryImpl({required LocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<List<Profile>> getProfiles() async {
    final profiles = await _localDataSource.getProfiles();
    if (profiles.isEmpty) {
      // Create a default profile if none exist
      final defaultProfile = Profile(
        id: 'default',
        name: 'Main',
        avatarId: 'avatar_1',
        isMain: true,
        createdAt: DateTime.now(),
      );
      await _localDataSource.saveProfiles([ProfileModel.fromEntity(defaultProfile)]);
      await _localDataSource.saveActiveProfile(defaultProfile.id);
      return [defaultProfile];
    }
    return profiles.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    final profiles = await _localDataSource.getProfiles();
    final existingProfile = profiles.where((p) => p.id == profile.id).firstOrNull;
    
    if (existingProfile != null) {
      // Update existing
      final updatedProfiles = profiles.map((p) {
        if (p.id == profile.id) {
          return ProfileModel.fromEntity(profile);
        }
        return p;
      }).toList();
      await _localDataSource.saveProfiles(updatedProfiles);
    } else {
      // Add new
      profiles.add(ProfileModel.fromEntity(profile));
      await _localDataSource.saveProfiles(profiles);
    }
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    final profiles = await _localDataSource.getProfiles();
    final updatedProfiles = profiles.where((p) => p.id != profileId).toList();
    await _localDataSource.saveProfiles(updatedProfiles);
    
    // If deleted profile was active, set first available as active
    final activeId = await _localDataSource.getActiveProfileId();
    if (activeId == profileId && updatedProfiles.isNotEmpty) {
      await _localDataSource.saveActiveProfile(updatedProfiles.first.id);
    }
  }

  @override
  Future<Profile?> getActiveProfile() async {
    final activeId = await _localDataSource.getActiveProfileId();
    if (activeId == null) return null;
    
    final profiles = await _localDataSource.getProfiles();
    final activeProfile = profiles.where((p) => p.id == activeId).firstOrNull;
    return activeProfile?.toEntity();
  }

  @override
  Future<void> setActiveProfile(String profileId) async {
    await _localDataSource.saveActiveProfile(profileId);
    
    // Update last active timestamp
    final profiles = await _localDataSource.getProfiles();
    final updatedProfiles = profiles.map((p) {
      if (p.id == profileId) {
        return p.copyWith(lastActiveAt: DateTime.now());
      }
      return p;
    }).toList();
    await _localDataSource.saveProfiles(updatedProfiles);
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    await saveProfile(profile);
  }
}
