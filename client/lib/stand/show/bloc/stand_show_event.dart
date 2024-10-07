part of 'stand_show_bloc.dart';

@immutable
sealed class StandShowEvent {}

class StandDataLoaded extends StandShowEvent {
  final int id;

  StandDataLoaded({required this.id});
}
