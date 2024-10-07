part of 'form_stand_bloc.dart';

enum FormStatus { initial, loading, success, error }

class FormStandState {
  final FormStatus status;
  final GlobalKey<FormState>? formKey;
  final String? errorMessage;
  final String? type;
  final String? name;
  final String? maxPoint;

  FormStandState({
    this.status = FormStatus.initial,
    this.formKey,
    this.errorMessage,
    this.type,
    this.name,
    this.maxPoint
  });

  FormStandState copyWith({
    FormStatus? status,
    GlobalKey<FormState>? formKey,
    String? errorMessage,
    String? type,
    String? name,
    String? maxPoint,
  }) {
    return FormStandState(
      status: status ?? this.status,
      formKey: formKey,
      errorMessage: errorMessage ?? this.errorMessage,
      type: type ?? this.type,
      name: name ?? this.name,
      maxPoint: maxPoint ?? this.maxPoint,
    );
  }
}