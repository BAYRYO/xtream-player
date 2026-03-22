import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository _movieRepository;

  MovieBloc({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(const MovieState()) {
    on<MovieCategoriesRequested>(_onCategoriesRequested);
    on<MovieListRequested>(_onMovieListRequested);
    on<MovieInfoRequested>(_onMovieInfoRequested);
    on<MovieSearchRequested>(_onMovieSearchRequested);
    on<MovieAllRequested>(_onMovieAllRequested);
  }

  Future<void> _onCategoriesRequested(
    MovieCategoriesRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: MovieStatus.loading));

    try {
      final categories = await _movieRepository.getCategories();
      emit(state.copyWith(
        status: MovieStatus.loaded,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MovieStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onMovieListRequested(
    MovieListRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(
      status: MovieStatus.loading,
      currentCategoryId: event.categoryId,
      currentCategoryName: event.categoryName,
    ));

    try {
      final movies = await _movieRepository.getMovies(event.categoryId);
      emit(state.copyWith(
        status: MovieStatus.loaded,
        movies: movies,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MovieStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onMovieInfoRequested(
    MovieInfoRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: MovieStatus.loading));

    try {
      final movie = await _movieRepository.getMovieInfo(event.movieId);
      emit(state.copyWith(
        status: MovieStatus.loaded,
        selectedMovie: movie,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MovieStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onMovieSearchRequested(
    MovieSearchRequested event,
    Emitter<MovieState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(
        isSearching: false,
        searchQuery: '',
        movies: [],
      ));
      return;
    }

    emit(state.copyWith(
      status: MovieStatus.loading,
      isSearching: true,
      searchQuery: event.query,
    ));

    try {
      final movies = await _movieRepository.searchMovies(event.query);
      emit(state.copyWith(
        status: MovieStatus.loaded,
        movies: movies,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MovieStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onMovieAllRequested(
    MovieAllRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(status: MovieStatus.loading));

    try {
      final movies = await _movieRepository.getAllMovies();
      emit(state.copyWith(
        status: MovieStatus.loaded,
        movies: movies,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MovieStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  String getMovieStreamUrl(String movieId) {
    return _movieRepository.getMovieStreamUrl(movieId);
  }
}
