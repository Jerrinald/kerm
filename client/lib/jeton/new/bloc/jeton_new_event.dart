
part of 'jeton_new_bloc.dart';

abstract class JetonNewEvent {}

class FormValidationSuccess extends JetonNewEvent {}

class EventDataLoaded extends JetonNewEvent {
  final int id;

  EventDataLoaded({required this.id});
}

class FormValidationError extends JetonNewEvent {
  final String message;

  FormValidationError({required this.message});
}

class ValidateFormEvent extends JetonNewEvent {
  final String nbJeton;

  ValidateFormEvent({required this.nbJeton});
}

class SubmitFormEvent extends JetonNewEvent {
  SubmitFormEvent({required this.onSuccess, required this.onError, required this.id});

  final int id;

  final VoidCallback onSuccess;
  final Function(String) onError;

  @override
  List<Object> get props => [onSuccess, onError, id];
}