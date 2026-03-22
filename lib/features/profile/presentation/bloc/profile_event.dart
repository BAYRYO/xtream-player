import 'package:equatable/equatable.dart';
import 'package:stream_xtream/features/profile/domain/entities/profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {}

class ProfileCreateRequested extends ProfileEvent {
  final String name;
  final String avatarId;

  const ProfileCreateRequested({
    required this.name,
    required this.avatarId,
  });

  @override
  List<Object?> get props => [name, avatarId];
}

class ProfileUpdateRequested extends ProfileEvent {
  final Profile profile;

  const ProfileUpdateRequested(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileDeleteRequested extends ProfileEvent {
  final String profileId;

  const ProfileDeleteRequested(this.profileId);

  @override
  List<Object?> get props => [profileId];
}

class ProfileSetActiveRequested extends ProfileEvent {
  final String profileId;

  const ProfileSetActiveRequested(this.profileId);

  @override
  List<Object?> get props => [profileId];
}
