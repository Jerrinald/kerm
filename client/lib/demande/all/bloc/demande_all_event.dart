part of 'demande_all_bloc.dart';

@immutable
sealed class DemandeAllEvent {}

class ActorsDataLoaded extends DemandeAllEvent {}

class UpdateActorEvent extends DemandeAllEvent {
  UpdateActorEvent({required this.onSuccess, required this.onError,
    required this.id, required this.active});

  final int id;
  final bool active;

  final VoidCallback onSuccess;
  final Function(String) onError;

  @override
  List<Object> get props => [onSuccess, onError, id, active];
}