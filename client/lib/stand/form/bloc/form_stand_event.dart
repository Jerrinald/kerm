part of 'form_stand_bloc.dart';

abstract class FormStandEvent {}

class FormValidationSuccess extends FormStandEvent {}

class FormValidationError extends FormStandEvent {
  final String message;

  FormValidationError({required this.message});
}

class ValidateFormEvent extends FormStandEvent {
  final String type;
  final String name;
  final String maxPoint;
  final bool isSubmit;

  ValidateFormEvent({required this.type, required this.maxPoint,
    required this.name, required this.isSubmit});
}

class SubmitFormEvent extends FormStandEvent {
  SubmitFormEvent({required this.onSuccess, required this.onError, required this.id});

  final int id;

  final VoidCallback onSuccess;
  final Function(String) onError;

  @override
  List<Object> get props => [onSuccess, onError, id];
}