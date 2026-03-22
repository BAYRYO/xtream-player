import '../../domain/entities/series.dart';

abstract class SeriesRepository {
  Future<List<SeriesCategory>> getCategories();
  Future<List<Series>> getSeries(String categoryId);
  Future<List<Series>> getAllSeries();
  Future<Series> getSeriesInfo(String seriesId);
  Future<List<Episode>> getEpisodes(String seriesId, String seasonId);
  Future<List<Series>> searchSeries(String query);
  String getSeriesStreamUrl(String seriesId, String season, String episode);
}
