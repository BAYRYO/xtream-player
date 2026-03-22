import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'player_event.dart';
import 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, VideoPlayerState> {
  late final mk.Player _player;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playingSubscription;
  StreamSubscription? _bufferingSubscription;
  StreamSubscription? _completedSubscription;

  PlayerBloc() : super(const VideoPlayerState()) {
    _player = mk.Player();
    
    on<PlayerInitialize>(_onInitialize);
    on<PlayerPlay>(_onPlay);
    on<PlayerPause>(_onPause);
    on<PlayerSeek>(_onSeek);
    on<PlayerSetVolume>(_onSetVolume);
    on<PlayerToggleFullscreen>(_onToggleFullscreen);
    on<PlayerSetPlaybackSpeed>(_onSetPlaybackSpeed);
    on<PlayerUpdatePosition>(_onUpdatePosition);
    on<PlayerDispose>(_onDispose);

    _setupListeners();
  }

  void _setupListeners() {
    _positionSubscription = _player.stream.position.listen((position) {
      add(PlayerUpdatePosition(position: position, duration: state.duration));
    });

    _durationSubscription = _player.stream.duration.listen((duration) {
      if (state.streamUrl != null) {
        add(PlayerUpdatePosition(position: state.position, duration: duration));
      }
    });

    _playingSubscription = _player.stream.playing.listen((playing) {
      if (playing && state.status != VideoPlayerStatus.playing) {
        add(PlayerUpdatePosition(
          position: state.position,
          duration: state.duration,
        ));
      }
    });

    _bufferingSubscription = _player.stream.buffering.listen((buffering) {
      // Buffering is handled via state
    });
  }

  mk.Player get player => _player;

  Future<void> _onInitialize(
    PlayerInitialize event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(state.copyWith(
      status: VideoPlayerStatus.loading,
      streamUrl: event.streamUrl,
      title: event.title,
      contentId: event.contentId,
      contentType: event.contentType,
      seasonNumber: event.seasonNumber,
      episodeNumber: event.episodeNumber,
      position: Duration.zero,
      duration: Duration.zero,
    ));

    try {
      await _player.open(mk.Media(event.streamUrl));
      await _player.pause();
      
      emit(state.copyWith(status: VideoPlayerStatus.paused));
    } catch (e) {
      emit(state.copyWith(
        status: VideoPlayerStatus.error,
        errorMessage: 'Failed to load video: ${e.toString()}',
      ));
    }
  }

  Future<void> _onPlay(
    PlayerPlay event,
    Emitter<VideoPlayerState> emit,
  ) async {
    await _player.play();
    emit(state.copyWith(status: VideoPlayerStatus.playing));
  }

  Future<void> _onPause(
    PlayerPause event,
    Emitter<VideoPlayerState> emit,
  ) async {
    await _player.pause();
    emit(state.copyWith(status: VideoPlayerStatus.paused));
  }

  Future<void> _onSeek(
    PlayerSeek event,
    Emitter<VideoPlayerState> emit,
  ) async {
    await _player.seek(event.position);
  }

  Future<void> _onSetVolume(
    PlayerSetVolume event,
    Emitter<VideoPlayerState> emit,
  ) async {
    await _player.setVolume(event.volume * 100);
    emit(state.copyWith(volume: event.volume));
  }

  Future<void> _onToggleFullscreen(
    PlayerToggleFullscreen event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(state.copyWith(isFullscreen: !state.isFullscreen));
  }

  Future<void> _onSetPlaybackSpeed(
    PlayerSetPlaybackSpeed event,
    Emitter<VideoPlayerState> emit,
  ) async {
    await _player.setRate(event.speed);
    emit(state.copyWith(playbackSpeed: event.speed));
  }

  void _onUpdatePosition(
    PlayerUpdatePosition event,
    Emitter<VideoPlayerState> emit,
  ) {
    emit(state.copyWith(
      position: event.position,
      duration: event.duration,
    ));

    // Mark as completed if near end
    if (event.duration.inSeconds > 0 &&
        event.position.inSeconds / event.duration.inSeconds > 0.95) {
      emit(state.copyWith(status: VideoPlayerStatus.completed));
    }
  }

  Future<void> _onDispose(
    PlayerDispose event,
    Emitter<VideoPlayerState> emit,
  ) async {
    await _player.dispose();
    emit(const VideoPlayerState());
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playingSubscription?.cancel();
    _bufferingSubscription?.cancel();
    _completedSubscription?.cancel();
    _player.dispose();
    return super.close();
  }
}
