import 'package:equatable/equatable.dart';
import 'package:stream_xtream/features/movies/domain/entities/movie.dart';
import 'package:stream_xtream/features/series/domain/entities/series.dart';

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
}

class HomeState extends Equatable {
  final HomeStatus status;
  final Movie? featuredMovie;
  final List<Movie> continueWatching;
  final List<Movie> recentMovies;
  final List<Series> popularSeries;
  final Map<String, List<Movie>> moviesByCategory;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.featuredMovie,
    this.continueWatching = const [],
    this.recentMovies = const [],
    this.popularSeries = const [],
    this.moviesByCategory = const {},
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    Movie? featuredMovie,
    List<Movie>? continueWatching,
    List<Movie>? recentMovies,
    List<Series>? popularSeries,
    Map<String, List<Movie>>? moviesByCategory,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      featuredMovie: featuredMovie ?? this.featuredMovie,
      continueWatching: continueWatching ?? this.continueWatching,
      recentMovies: recentMovies ?? this.recentMovies,
      popularSeries: popularSeries ?? this.popularSeries,
      moviesByCategory: moviesByCategory ?? this.moviesByCategory,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        featuredMovie,
        continueWatching,
        recentMovies,
        popularSeries,
        moviesByCategory,
        errorMessage,
      ];
}
