import 'package:equatable/equatable.dart';
import 'package:stream_xtream/features/movies/domain/entities/movie.dart';

enum VideoPlayerStatus {
  initial,
  loading,
  ready,
  playing,
  paused,
  error,
  completed,
}

class VideoPlayerState extends Equatable {
  final VideoPlayerStatus status;
  final String? streamUrl;
  final String title;
  final int? contentId;
  final ContentType contentType;
  final int? seasonNumber;
  final int? episodeNumber;
  final Duration position;
  final Duration duration;
  final double volume;
  final bool isFullscreen;
  final double playbackSpeed;
  final String? errorMessage;
  final bool isBuffering;

  const VideoPlayerState({
    this.status = VideoPlayerStatus.initial,
    this.streamUrl,
    this.title = '',
    this.contentId,
    this.contentType = ContentType.movie,
    this.seasonNumber,
    this.episodeNumber,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 1.0,
    this.isFullscreen = false,
    this.playbackSpeed = 1.0,
    this.errorMessage,
    this.isBuffering = false,
  });

  double get progress => duration.inMilliseconds > 0
      ? position.inMilliseconds / duration.inMilliseconds
      : 0.0;

  String get positionString => _formatDuration(position);
  String get durationString => _formatDuration(duration);

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  VideoPlayerState copyWith({
    VideoPlayerStatus? status,
    String? streamUrl,
    String? title,
    int? contentId,
    ContentType? contentType,
    int? seasonNumber,
    int? episodeNumber,
    Duration? position,
    Duration? duration,
    double? volume,
    bool? isFullscreen,
    double? playbackSpeed,
    String? errorMessage,
    bool? isBuffering,
  }) {
    return VideoPlayerState(
      status: status ?? this.status,
      streamUrl: streamUrl ?? this.streamUrl,
      title: title ?? this.title,
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      errorMessage: errorMessage,
      isBuffering: isBuffering ?? this.isBuffering,
    );
  }

  @override
  List<Object?> get props => [
        status,
        streamUrl,
        title,
        contentId,
        contentType,
        seasonNumber,
        episodeNumber,
        position,
        duration,
        volume,
        isFullscreen,
        playbackSpeed,
        errorMessage,
        isBuffering,
      ];
}
