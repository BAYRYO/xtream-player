import 'package:equatable/equatable.dart';
import '../../domain/entities/series.dart';

enum SeriesStatus {
  initial,
  loading,
  loaded,
  error,
}

class SeriesState extends Equatable {
  final SeriesStatus status;
  final List<SeriesCategory> categories;
  final List<Series> seriesList;
  final Series? selectedSeries;
  final List<Season>? selectedSeasons;
  final List<Episode>? selectedEpisodes;
  final String? currentCategoryId;
  final String? currentCategoryName;
  final String? errorMessage;
  final bool isSearching;
  final String searchQuery;

  const SeriesState({
    this.status = SeriesStatus.initial,
    this.categories = const [],
    this.seriesList = const [],
    this.selectedSeries,
    this.selectedSeasons,
    this.selectedEpisodes,
    this.currentCategoryId,
    this.currentCategoryName,
    this.errorMessage,
    this.isSearching = false,
    this.searchQuery = '',
  });

  SeriesState copyWith({
    SeriesStatus? status,
    List<SeriesCategory>? categories,
    List<Series>? seriesList,
    Series? selectedSeries,
    List<Season>? selectedSeasons,
    List<Episode>? selectedEpisodes,
    String? currentCategoryId,
    String? currentCategoryName,
    String? errorMessage,
    bool? isSearching,
    String? searchQuery,
  }) {
    return SeriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      seriesList: seriesList ?? this.seriesList,
      selectedSeries: selectedSeries ?? this.selectedSeries,
      selectedSeasons: selectedSeasons ?? this.selectedSeasons,
      selectedEpisodes: selectedEpisodes ?? this.selectedEpisodes,
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
        seriesList,
        selectedSeries,
        selectedSeasons,
        selectedEpisodes,
        currentCategoryId,
        currentCategoryName,
        errorMessage,
        isSearching,
        searchQuery,
      ];
}
