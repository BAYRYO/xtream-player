import 'package:stream_xtream/features/movies/domain/entities/movie.dart';
import 'package:stream_xtream/features/movies/domain/repositories/movie_repository.dart';
import 'package:stream_xtream/core/network/xtream_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final XtreamDataSource _xtreamDataSource;

  MovieRepositoryImpl({required XtreamDataSource xtreamDataSource})
      : _xtreamDataSource = xtreamDataSource;

  @override
  Future<List<MovieCategory>> getCategories() async {
    return await _xtreamDataSource.getMovieCategories();
  }

  @override
  Future<List<Movie>> getMovies(String categoryId) async {
    return await _xtreamDataSource.getMovies(categoryId);
  }

  @override
  Future<List<Movie>> getAllMovies() async {
    final categories = await _xtreamDataSource.getMovieCategories();
    final allMovies = <Movie>[];
    
    for (final category in categories) {
      final movies = await _xtreamDataSource.getMovies(category.id.toString());
      allMovies.addAll(movies);
    }
    
    return allMovies;
  }

  @override
  Future<Movie> getMovieInfo(String movieId) async {
    return await _xtreamDataSource.getMovieInfo(movieId);
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final allMovies = await getAllMovies();
    final queryLower = query.toLowerCase();
    
    return allMovies.where((movie) {
      return movie.title.toLowerCase().contains(queryLower) ||
          (movie.titleTranslated?.toLowerCase().contains(queryLower) ?? false) ||
          (movie.genre?.toLowerCase().contains(queryLower) ?? false);
    }).toList();
  }

  @override
  String getMovieStreamUrl(String movieId) {
    return _xtreamDataSource.getMovieStreamUrl(movieId);
  }
}
