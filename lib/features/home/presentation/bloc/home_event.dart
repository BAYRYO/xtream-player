import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoadRequested extends HomeEvent {}

class HomeLoadMoreRequested extends HomeEvent {}

class HomeRefreshRequested extends HomeEvent {}

class HomeLoadCategoryRequested extends HomeEvent {
  final String categoryId;
  final String categoryName;
  
  const HomeLoadCategoryRequested({required this.categoryId, required this.categoryName});
  
  @override
  List<Object?> get props => [categoryId, categoryName];
}
