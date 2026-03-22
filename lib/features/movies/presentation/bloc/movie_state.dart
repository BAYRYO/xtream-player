import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

enum MovieStatus {
  initial,
  loading,
  loaded,
  error,
}

class MovieState extends Equatable {
  final MovieStatus status;
  final List<MovieCategory> categories;
  final List<Movie> movies;
  final Movie? selectedMovie;
  final String? currentCategoryId;
  final String? currentCategoryName;
  final String? errorMessage;
  final bool isSearching;
  final String searchQuery;

  const MovieState({
    this.status = MovieStatus.initial,
    this.categories = const [],
    this.movies = const [],
    this.selectedMovie,
    this.currentCategoryId,
    this.currentCategoryName,
    this.errorMessage,
    this.isSearching = false,
    this.searchQuery = '',
  });

  MovieState copyWith({
    MovieStatus? status,
    List<MovieCategory>? categories,
    List<Movie>? movies,
    Movie? selectedMovie,
    String? currentCategoryId,
    String? currentCategoryName,
    String? errorMessage,
    bool? isSearching,
    String? searchQuery,
  }) {
    return MovieState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      movies: movies ?? this.movies,
      selectedMovie: selectedMovie ?? this.selectedMovie,
      currentCategoryId: currentCategoryId ?? this.currentCategoryId,
      currentCategoryName: currentCategoryName ?? this.currentCategoryName,
      errorMessage: errorMessage,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        movies,
        selectedMovie,
        currentCategoryId,
        currentCategoryName,
        errorMessage,
        isSearching,
        searchQuery,
      ];
}
