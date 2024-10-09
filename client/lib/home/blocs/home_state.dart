part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeDataLoadSuccess extends HomeState {
  final List<Kermesse> myKermesses;
  final List<Kermesse> allKermesses;
  final String role;

  HomeDataLoadSuccess({required this.myKermesses, required this.allKermesses,
  required this.role});
}


final class HomeDataLoadError extends HomeState {
  final String errorMessage;

  HomeDataLoadError({required this.errorMessage});
}
