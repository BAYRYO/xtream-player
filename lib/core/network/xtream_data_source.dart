import 'package:stream_xtream/core/network/dio_client.dart';
import 'package:stream_xtream/core/constants/api_constants.dart';
import 'package:stream_xtream/features/auth/data/models/user_model.dart';
import 'package:stream_xtream/features/movies/data/models/movie_model.dart';
import 'package:stream_xtream/features/series/data/models/series_model.dart';
import 'package:stream_xtream/features/series/domain/entities/series.dart';

abstract class XtreamDataSource {
  Future<UserModel> authenticate(String serverUrl, String username, String password);
  Future<List<MovieCategoryModel>> getMovieCategories();
  Future<List<MovieModel>> getMovies(String categoryId);
  Future<MovieModel> getMovieInfo(String movieId);
  Future<List<SeriesCategoryModel>> getSeriesCategories();
  Future<List<SeriesModel>> getSeries(String categoryId);
  Future<SeriesModel> getSeriesInfo(String seriesId);
  Future<List<Season>> getSeasons(String seriesId);
  Future<List<EpisodeModel>> getEpisodes(String seriesId, String seasonId);
  String getMovieStreamUrl(String movieId);
  String getSeriesStreamUrl(String seriesId, String season, String episode);
  String getLiveStreamUrl(String channelId);
}

class XtreamDataSourceImpl implements XtreamDataSource {
  final DioClient _dioClient;
  String? _serverUrl;

  XtreamDataSourceImpl(this._dioClient);

  void _updateCredentials(String serverUrl, String username, String password) {
    _serverUrl = serverUrl;
    _dioClient.updateCredentials(
      baseUrl: serverUrl,
      username: username,
      password: password,
    );
  }

  String get _baseServerUrl {
    if (_serverUrl == null) {
      throw Exception('Not authenticated');
    }
    return _serverUrl!;
  }

  @override
  Future<UserModel> authenticate(String serverUrl, String username, String password) async {
    _updateCredentials(serverUrl, username, password);
    
    try {
      // For authentication, don't pass action parameter - Xtream expects just username/password
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiConstants.defaultApiPath,
      );

      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      final userData = response.data!;
      
      // Check for auth errors - Xtream returns user_info
      if (userData.containsKey('user_info')) {
        final userInfo = userData['user_info'];
        if (userInfo is Map<String, dynamic>) {
          return UserModel.fromJson({
            ...userInfo,
            'username': username,
            'password': password,
          });
        }
      }
      
      // Check legacy format
      if (userData.containsKey('user')) {
        final user = userData['user'];
        if (user is Map<String, dynamic>) {
          return UserModel.fromJson({
            ...user,
            'username': username,
            'password': password,
          });
        }
      }
      
      // Check for error status
      if (userData['status'] != null && userData['status'] != 'OK') {
        final status = userData['status'].toString();
        final message = userData['message'] ?? 'Authentication failed';
        throw Exception('$message (status: $status)');
      }

      throw Exception('Invalid response format');
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('Connection')) {
        throw Exception('Cannot connect to server. Please check your server URL.');
      }
      rethrow;
    }
  }

  @override
  Future<List<MovieCategoryModel>> getMovieCategories() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiConstants.defaultApiPath,
        queryParameters: {'action': ApiConstants.getMoviesAction},
      );

      if (response.data == null) return [];

      final categories = response.data![ApiConstants.categoriesKey];
      if (categories == null) return [];

      return (categories as List)
          .map((c) => MovieCategoryModel.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<MovieModel>> getMovies(String categoryId) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiConstants.defaultApiPath,
        queryParameters: {
          'action': ApiConstants.getMoviesListAction,
          'category_id': categoryId,
        },
      );

      if (response.data == null) return [];

      // Xtream returns movies directly in response.data (not under 'movies' key)
      final movies = response.data;
      if (movies is! List) {
        // Try 'movies' key as fallback
        final moviesKey = response.data![ApiConstants.moviesKey];
        if (moviesKey == null) return [];
        return (moviesKey as List)
            .map((m) => MovieModel.fromJson(
                  m as Map<String, dynamic>,
                  serverUrl: _baseServerUrl,
                ))
            .toList();
      }

      return (movies as List)
          .map((m) => MovieModel.fromJson(
                m as Map<String, dynamic>,
                serverUrl: _baseServerUrl,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<MovieModel> getMovieInfo(String movieId) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiConstants.defaultApiPath,
      queryParameters: {
        'action': ApiConstants.getMovieInfoAction,
        'vod_id': movieId,
      },
    );

    if (response.data == null) {
      throw Exception('Movie not found');
    }

    return MovieModel.fromJson(
      response.data!,
      serverUrl: _baseServerUrl,
    );
  }

  @override
  Future<List<SeriesCategoryModel>> getSeriesCategories() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiConstants.defaultApiPath,
        queryParameters: {'action': ApiConstants.getSeriesAction},
      );

      if (response.data == null) return [];

      final categories = response.data![ApiConstants.categoriesKey];
      if (categories == null) return [];

      return (categories as List)
          .map((c) => SeriesCategoryModel.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<SeriesModel>> getSeries(String categoryId) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiConstants.defaultApiPath,
        queryParameters: {
          'action': ApiConstants.getSeriesAction,
          'category_id': categoryId,
        },
      );

      if (response.data == null) return [];

      final series = response.data![ApiConstants.seriesKey];
      if (series == null) return [];

      return (series as List)
          .map((s) => SeriesModel.fromJson(
                s as Map<String, dynamic>,
                serverUrl: _baseServerUrl,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<SeriesModel> getSeriesInfo(String seriesId) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiConstants.defaultApiPath,
      queryParameters: {
        'action': ApiConstants.getSeriesInfoAction,
        'series_id': seriesId,
      },
    );

    if (response.data == null) {
      throw Exception('Series not found');
    }

    return SeriesModel.fromJsonWithSeasons(
      response.data!,
      response.data!,
      serverUrl: _baseServerUrl,
    );
  }

  @override
  Future<List<Season>> getSeasons(String seriesId) async {
    final seriesInfo = await getSeriesInfo(seriesId);
    return seriesInfo.seasons ?? [];
  }

  @override
  Future<List<EpisodeModel>> getEpisodes(String seriesId, String seasonId) async {
    // In Xtream API, episodes are included in series info
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiConstants.defaultApiPath,
      queryParameters: {
        'action': ApiConstants.getSeriesInfoAction,
        'series_id': seriesId,
      },
    );

    if (response.data == null) return [];

    final episodesData = response.data!['episodes'] as Map<String, dynamic>?;
    if (episodesData == null) return [];

    final seasonEpisodes = episodesData[seasonId];
    if (seasonEpisodes == null) return [];

    return (seasonEpisodes as List)
        .map((e) => EpisodeModel.fromJson(
              e as Map<String, dynamic>,
              serverUrl: _baseServerUrl,
              seasonId: int.tryParse(seasonId) ?? 0,
            ))
        .toList();
  }

  @override
  String getMovieStreamUrl(String movieId) {
    return _dioClient.getMovieStreamUrl(movieId);
  }

  @override
  String getSeriesStreamUrl(String seriesId, String season, String episode) {
    return _dioClient.getSeriesStreamUrl(seriesId, season, episode);
  }

  @override
  String getLiveStreamUrl(String channelId) {
    return _dioClient.getLiveStreamUrl(channelId);
  }
}
