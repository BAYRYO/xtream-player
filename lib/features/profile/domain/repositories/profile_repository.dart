import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<List<Profile>> getProfiles();
  Future<void> saveProfile(Profile profile);
  Future<void> deleteProfile(String profileId);
  Future<Profile?> getActiveProfile();
  Future<void> setActiveProfile(String profileId);
  Future<void> updateProfile(Profile profile);
}
