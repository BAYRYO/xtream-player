import 'package:stream_xtream/features/series/domain/entities/series.dart';
import 'package:stream_xtream/features/series/domain/repositories/series_repository.dart';
import 'package:stream_xtream/core/network/xtream_data_source.dart';

class SeriesRepositoryImpl implements SeriesRepository {
  final XtreamDataSource _xtreamDataSource;

  SeriesRepositoryImpl({required XtreamDataSource xtreamDataSource})
      : _xtreamDataSource = xtreamDataSource;

  @override
  Future<List<SeriesCategory>> getCategories() async {
    return await _xtreamDataSource.getSeriesCategories();
  }

  @override
  Future<List<Series>> getSeries(String categoryId) async {
    return await _xtreamDataSource.getSeries(categoryId);
  }

  @override
  Future<List<Series>> getAllSeries() async {
    final categories = await _xtreamDataSource.getSeriesCategories();
    final allSeries = <Series>[];
    
    for (final category in categories) {
      final series = await _xtreamDataSource.getSeries(category.id.toString());
      allSeries.addAll(series);
    }
    
    return allSeries;
  }

  @override
  Future<Series> getSeriesInfo(String seriesId) async {
    return await _xtreamDataSource.getSeriesInfo(seriesId);
  }

  @override
  Future<List<Episode>> getEpisodes(String seriesId, String seasonId) async {
    return await _xtreamDataSource.getEpisodes(seriesId, seasonId);
  }

  @override
  Future<List<Series>> searchSeries(String query) async {
    final allSeries = await getAllSeries();
    final queryLower = query.toLowerCase();
    
    return allSeries.where((series) {
      return series.name.toLowerCase().contains(queryLower) ||
          (series.nameTranslated?.toLowerCase().contains(queryLower) ?? false) ||
          (series.genre?.toLowerCase().contains(queryLower) ?? false);
    }).toList();
  }

  @override
  String getSeriesStreamUrl(String seriesId, String season, String episode) {
    return _xtreamDataSource.getSeriesStreamUrl(seriesId, season, episode);
  }
}
