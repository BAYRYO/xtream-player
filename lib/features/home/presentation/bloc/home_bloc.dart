import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_xtream/features/movies/domain/entities/movie.dart';
import 'package:stream_xtream/features/movies/domain/repositories/movie_repository.dart';
import 'package:stream_xtream/features/series/domain/entities/series.dart';
import 'package:stream_xtream/features/series/domain/repositories/series_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository _movieRepository;
  final SeriesRepository _seriesRepository;

  HomeBloc({
    required MovieRepository movieRepository,
    required SeriesRepository seriesRepository,
  })  : _movieRepository = movieRepository,
        _seriesRepository = seriesRepository,
        super(const HomeState()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      // Load featured movie (first movie with high rating)
      final allMovies = await _movieRepository.getAllMovies();
      final featuredMovie = allMovies.isNotEmpty ? allMovies.first : null;

      // Load series
      final allSeries = await _seriesRepository.getAllSeries();

      // Get movies by category
      final categories = await _movieRepository.getCategories();
      final moviesByCategory = <String, List<dynamic>>{};
      
      for (final category in categories.take(5)) {
        final movies = await _movieRepository.getMovies(category.id.toString());
        if (movies.isNotEmpty) {
          moviesByCategory[category.name] = movies;
        }
      }

      emit(state.copyWith(
        status: HomeStatus.loaded,
        featuredMovie: featuredMovie,
        recentMovies: allMovies.take(10).toList(),
        popularSeries: allSeries.take(10).toList(),
        moviesByCategory: Map<String, List<Movie>>.from(moviesByCategory.map(
          (key, value) => MapEntry(key, value.cast<Movie>()),
        )),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    add(HomeLoadRequested());
  }
}
