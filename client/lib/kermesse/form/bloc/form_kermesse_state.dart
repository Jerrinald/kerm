part of 'form_kermesse_bloc.dart';

enum FormStatus { initial, loading, success, error }

class FormKermesseState {
  final FormStatus status;
  final GlobalKey<FormState>? formKey;
  final String? errorMessage;
  final String? name;

  FormKermesseState({
    this.status = FormStatus.initial,
    this.formKey,
    this.errorMessage,
    this.name
  });

  FormKermesseState copyWith({
    FormStatus? status,
    GlobalKey<FormState>? formKey,
    String? errorMessage,
    String? name,
  }) {
    return FormKermesseState(
      status: status ?? this.status,
      formKey: formKey,
      errorMessage: errorMessage ?? this.errorMessage,
      name: name ?? this.name,
    );
  }
}