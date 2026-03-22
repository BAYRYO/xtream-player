import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../series/domain/entities/series.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoadRequested extends HomeEvent {}

class HomeRefreshRequested extends HomeEvent {}
