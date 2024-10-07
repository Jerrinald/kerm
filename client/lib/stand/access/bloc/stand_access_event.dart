part of 'stand_access_bloc.dart';

@immutable
sealed class StandAccessEvent {}

class StandAccessDataLoaded extends StandAccessEvent {
  final int id;

  StandAccessDataLoaded({required this.id});
}


class ValidateFormEvent extends StandAccessEvent {
  final String nbJeton;

  ValidateFormEvent({required this.nbJeton});
}


class SubmitFormEvent extends StandAccessEvent {
  SubmitFormEvent({required this.onSuccess, required this.onError, required this.id});

  final int id;

  final VoidCallback onSuccess;
  final Function(String) onError;

  @override
  List<Object> get props => [onSuccess, onError, id];
}

class ActivityGameEvent extends StandAccessEvent {
  ActivityGameEvent({required this.onSuccess, required this.onError, required this.id,
  required this.onLose});

  final int id;

  final VoidCallback onSuccess;
  final VoidCallback onLose;
  final Function(String) onError;

  @override
  List<Object> get props => [onSuccess, onError, onLose, id];
}