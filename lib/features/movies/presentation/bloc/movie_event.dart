import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class MovieCategoriesRequested extends MovieEvent {}

class MovieListRequested extends MovieEvent {
  final String categoryId;
  final String categoryName;

  const MovieListRequested({
    required this.categoryId,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [categoryId, categoryName];
}

class MovieInfoRequested extends MovieEvent {
  final String movieId;

  const MovieInfoRequested(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class MovieSearchRequested extends MovieEvent {
  final String query;

  const MovieSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class MovieAllRequested extends MovieEvent {}
