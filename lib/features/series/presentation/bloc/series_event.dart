import 'package:equatable/equatable.dart';

abstract class SeriesEvent extends Equatable {
  const SeriesEvent();

  @override
  List<Object?> get props => [];
}

class SeriesCategoriesRequested extends SeriesEvent {}

class SeriesListRequested extends SeriesEvent {
  final String categoryId;
  final String categoryName;

  const SeriesListRequested({
    required this.categoryId,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [categoryId, categoryName];
}

class SeriesInfoRequested extends SeriesEvent {
  final String seriesId;

  const SeriesInfoRequested(this.seriesId);

  @override
  List<Object?> get props => [seriesId];
}

class SeriesSearchRequested extends SeriesEvent {
  final String query;

  const SeriesSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class SeriesAllRequested extends SeriesEvent {}
