part of 'form_kermesse_bloc.dart';

abstract class FormKermesseEvent {}

class FormValidationSuccess extends FormKermesseEvent {}

class FormValidationError extends FormKermesseEvent {
  final String message;

  FormValidationError({required this.message});
}

class ValidateFormEvent extends FormKermesseEvent {
  final String name;

  ValidateFormEvent({required this.name});
}

class SubmitFormEvent extends FormKermesseEvent {
  SubmitFormEvent({required this.onSuccess, required this.onError});

  final VoidCallback onSuccess;
  final Function(String) onError;

  @override
  List<Object> get props => [onSuccess, onError];
}