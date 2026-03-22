import '../../domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<MovieCategory>> getCategories();
  Future<List<Movie>> getMovies(String categoryId);
  Future<List<Movie>> getAllMovies();
  Future<Movie> getMovieInfo(String movieId);
  Future<List<Movie>> searchMovies(String query);
  String getMovieStreamUrl(String movieId);
}
