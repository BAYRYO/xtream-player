import 'package:equatable/equatable.dart';
import 'package:stream_xtream/features/movies/domain/entities/movie.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlayerInitialize extends PlayerEvent {
  final String streamUrl;
  final String title;
  final int? contentId;
  final ContentType contentType;
  final int? seasonNumber;
  final int? episodeNumber;

  const PlayerInitialize({
    required this.streamUrl,
    required this.title,
    this.contentId,
    required this.contentType,
    this.seasonNumber,
    this.episodeNumber,
  });

  @override
  List<Object?> get props => [
        streamUrl,
        title,
        contentId,
        contentType,
        seasonNumber,
        episodeNumber,
      ];
}

class PlayerPlay extends PlayerEvent {}

class PlayerPause extends PlayerEvent {}

class PlayerSeek extends PlayerEvent {
  final Duration position;

  const PlayerSeek(this.position);

  @override
  List<Object?> get props => [position];
}

class PlayerSetVolume extends PlayerEvent {
  final double volume;

  const PlayerSetVolume(this.volume);

  @override
  List<Object?> get props => [volume];
}

class PlayerToggleFullscreen extends PlayerEvent {}

class PlayerSetPlaybackSpeed extends PlayerEvent {
  final double speed;

  const PlayerSetPlaybackSpeed(this.speed);

  @override
  List<Object?> get props => [speed];
}

class PlayerUpdatePosition extends PlayerEvent {
  final Duration position;
  final Duration duration;

  const PlayerUpdatePosition({
    required this.position,
    required this.duration,
  });

  @override
  List<Object?> get props => [position, duration];
}

class PlayerDispose extends PlayerEvent {}
