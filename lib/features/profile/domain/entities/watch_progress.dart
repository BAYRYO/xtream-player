import 'package:equatable/equatable.dart';

enum WatchStatus {
  notStarted,
  inProgress,
  completed,
}

class WatchProgress extends Equatable {
  final String id;
  final String profileId;
  final int contentId;
  final ContentType contentType;
  final int? seasonNumber;
  final int? episodeNumber;
  final Duration position;
  final Duration totalDuration;
  final WatchStatus status;
  final DateTime lastWatched;
  final int? rating;

  const WatchProgress({
    required this.id,
    required this.profileId,
    required this.contentId,
    required this.contentType,
    this.seasonNumber,
    this.episodeNumber,
    required this.position,
    required this.totalDuration,
    required this.status,
    required this.lastWatched,
    this.rating,
  });

  double get progressPercent {
    if (totalDuration.inSeconds == 0) return 0;
    return (position.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
  }

  bool get isCompleted => progressPercent >= 0.9;

  WatchProgress copyWith({
    String? id,
    String? profileId,
    int? contentId,
    ContentType? contentType,
    int? seasonNumber,
    int? episodeNumber,
    Duration? position,
    Duration? totalDuration,
    WatchStatus? status,
    DateTime? lastWatched,
    int? rating,
  }) {
    return WatchProgress(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      position: position ?? this.position,
      totalDuration: totalDuration ?? this.totalDuration,
      status: status ?? this.status,
      lastWatched: lastWatched ?? this.lastWatched,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props => [
        id,
        profileId,
        contentId,
        contentType,
        seasonNumber,
        episodeNumber,
        position,
        totalDuration,
        status,
        lastWatched,
        rating,
      ];
}

enum ContentType {
  movie,
  series,
  live,
}
