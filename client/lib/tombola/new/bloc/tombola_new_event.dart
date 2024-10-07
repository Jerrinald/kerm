
part of 'tombola_new_bloc.dart';

abstract class TombolaNewEvent {}

class FormValidationSuccess extends TombolaNewEvent {}

class EventDataLoaded extends TombolaNewEvent {
  final int id;

  EventDataLoaded({required this.id});
}

class FormValidationError extends TombolaNewEvent {
  final String message;

  FormValidationError({required this.message});
}

class ValidateFormEvent extends TombolaNewEvent {
  final String nbJeton;

  ValidateFormEvent({required this.nbJeton});
}

class SubmitFormEvent extends TombolaNewEvent {
  SubmitFormEvent({required this.onSuccess, required this.onError, required this.id});

  final int id;

  final VoidCallback onSuccess;
  final Function(String) onError;

  @override
  List<Object> get props => [onSuccess, onError, id];
}