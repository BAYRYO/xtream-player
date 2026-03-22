import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/series_repository.dart';
import 'series_event.dart';
import 'series_state.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final SeriesRepository _seriesRepository;

  SeriesBloc({required SeriesRepository seriesRepository})
      : _seriesRepository = seriesRepository,
        super(const SeriesState()) {
    on<SeriesCategoriesRequested>(_onCategoriesRequested);
    on<SeriesListRequested>(_onSeriesListRequested);
    on<SeriesInfoRequested>(_onSeriesInfoRequested);
    on<SeriesSearchRequested>(_onSeriesSearchRequested);
    on<SeriesAllRequested>(_onSeriesAllRequested);
  }

  Future<void> _onCategoriesRequested(
    SeriesCategoriesRequested event,
    Emitter<SeriesState> emit,
  ) async {
    emit(state.copyWith(status: SeriesStatus.loading));

    try {
      final categories = await _seriesRepository.getCategories();
      emit(state.copyWith(
        status: SeriesStatus.loaded,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SeriesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSeriesListRequested(
    SeriesListRequested event,
    Emitter<SeriesState> emit,
  ) async {
    emit(state.copyWith(
      status: SeriesStatus.loading,
      currentCategoryId: event.categoryId,
      currentCategoryName: event.categoryName,
    ));

    try {
      final seriesList = await _seriesRepository.getSeries(event.categoryId);
      emit(state.copyWith(
        status: SeriesStatus.loaded,
        seriesList: seriesList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SeriesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSeriesInfoRequested(
    SeriesInfoRequested event,
    Emitter<SeriesState> emit,
  ) async {
    emit(state.copyWith(status: SeriesStatus.loading));

    try {
      final series = await _seriesRepository.getSeriesInfo(event.seriesId);
      emit(state.copyWith(
        status: SeriesStatus.loaded,
        selectedSeries: series,
        selectedSeasons: series.seasons,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SeriesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSeriesSearchRequested(
    SeriesSearchRequested event,
    Emitter<SeriesState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(
        isSearching: false,
        searchQuery: '',
        seriesList: [],
      ));
      return;
    }

    emit(state.copyWith(
      status: SeriesStatus.loading,
      isSearching: true,
      searchQuery: event.query,
    ));

    try {
      final seriesList = await _seriesRepository.searchSeries(event.query);
      emit(state.copyWith(
        status: SeriesStatus.loaded,
        seriesList: seriesList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SeriesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSeriesAllRequested(
    SeriesAllRequested event,
    Emitter<SeriesState> emit,
  ) async {
    emit(state.copyWith(status: SeriesStatus.loading));

    try {
      final seriesList = await _seriesRepository.getAllSeries();
      emit(state.copyWith(
        status: SeriesStatus.loaded,
        seriesList: seriesList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SeriesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  String getSeriesStreamUrl(String seriesId, String season, String episode) {
    return _seriesRepository.getSeriesStreamUrl(seriesId, season, episode);
  }
}
