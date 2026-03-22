import 'package:equatable/equatable.dart';
import 'package:stream_xtream/features/profile/domain/entities/profile.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final List<Profile> profiles;
  final Profile? activeProfile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profiles = const [],
    this.activeProfile,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    List<Profile>? profiles,
    Profile? activeProfile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      activeProfile: activeProfile ?? this.activeProfile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profiles, activeProfile, errorMessage];
}
