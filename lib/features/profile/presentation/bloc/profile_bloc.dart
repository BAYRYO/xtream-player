import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:stream_xtream/features/profile/domain/entities/profile.dart';
import 'package:stream_xtream/features/profile/domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final Uuid _uuid = const Uuid();

  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const ProfileState()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileCreateRequested>(_onProfileCreateRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileDeleteRequested>(_onProfileDeleteRequested);
    on<ProfileSetActiveRequested>(_onProfileSetActiveRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final profiles = await _profileRepository.getProfiles();
      final activeProfile = await _profileRepository.getActiveProfile();

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profiles: profiles,
        activeProfile: activeProfile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onProfileCreateRequested(
    ProfileCreateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final newProfile = Profile(
        id: _uuid.v4(),
        name: event.name,
        avatarId: event.avatarId,
        createdAt: DateTime.now(),
      );

      await _profileRepository.saveProfile(newProfile);
      add(ProfileLoadRequested());
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileRepository.updateProfile(event.profile);
      add(ProfileLoadRequested());
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onProfileDeleteRequested(
    ProfileDeleteRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileRepository.deleteProfile(event.profileId);
      add(ProfileLoadRequested());
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onProfileSetActiveRequested(
    ProfileSetActiveRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileRepository.setActiveProfile(event.profileId);
      add(ProfileLoadRequested());
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
