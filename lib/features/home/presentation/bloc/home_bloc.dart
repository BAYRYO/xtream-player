import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_xtream/features/movies/domain/entities/movie.dart' as movie_entity;
import 'package:stream_xtream/features/movies/domain/entities/movie.dart';
import 'package:stream_xtream/features/movies/domain/repositories/movie_repository.dart';
import 'package:stream_xtream/features/series/domain/entities/series.dart';
import 'package:stream_xtream/features/series/domain/repositories/series_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

typedef MovieCategory = movie_entity.MovieCategory;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository _movieRepository;
  final SeriesRepository _seriesRepository;
  List<MovieCategory> _categories = [];

  HomeBloc({
    required MovieRepository movieRepository,
    required SeriesRepository seriesRepository,
  })  : _movieRepository = movieRepository,
        _seriesRepository = seriesRepository,
        super(const HomeState()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeLoadMoreRequested>(_onLoadMoreRequested);
    on<HomeLoadCategoryRequested>(_onLoadCategoryRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      // Only load categories first - don't load all movies at once
      _categories = await _movieRepository.getCategories();
      
      // Load just featured movie and a few recent ones
      final recentMovies = await _movieRepository.getMovies(
        _categories.isNotEmpty ? _categories.first.id.toString() : '0',
      );
      
      // Load some series
      final popularSeries = await _seriesRepository.getSeries(
        _categories.isNotEmpty ? _categories.first.id.toString() : '0',
      );

      emit(state.copyWith(
        status: HomeStatus.loaded,
        featuredMovie: recentMovies.isNotEmpty ? recentMovies.first : null,
        recentMovies: recentMovies.take(10).toList(),
        popularSeries: popularSeries.take(10).toList(),
        moviesByCategory: {},
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreRequested(
    HomeLoadMoreRequested event,
    Emitter<HomeState> emit,
  ) async {
    // Load more categories lazily when user scrolls
    final currentCategoriesCount = state.moviesByCategory.length;
    final nextCategories = _categories.skip(currentCategoriesCount).take(3);
    
    final newMoviesByCategory = Map<String, List<Movie>>.from(state.moviesByCategory);
    
    for (final category in nextCategories) {
      final movies = await _movieRepository.getMovies(category.id.toString());
      if (movies.isNotEmpty) {
        newMoviesByCategory[category.name] = movies.take(10).toList();
      }
    }

    emit(state.copyWith(
      moviesByCategory: newMoviesByCategory,
    ));
  }

  Future<void> _onLoadCategoryRequested(
    HomeLoadCategoryRequested event,
    Emitter<HomeState> emit,
  ) async {
    // Load movies for a specific category
    if (state.moviesByCategory.containsKey(event.categoryName)) {
      return; // Already loaded
    }
    
    final movies = await _movieRepository.getMovies(event.categoryId);
    
    final newMoviesByCategory = Map<String, List<Movie>>.from(state.moviesByCategory);
    newMoviesByCategory[event.categoryName] = movies;
    
    emit(state.copyWith(
      moviesByCategory: newMoviesByCategory,
    ));
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    add(HomeLoadRequested());
  }
}
