part of 'tombola_new_bloc.dart';

enum TombolaNewStatus { initial, loading, success, error }

class TombolaNewState {
  final TombolaNewStatus status;
  final GlobalKey<FormState>? formKey;
  final String? errorMessage;
  final Kermesse? kermesse;
  final Actor? actor;
  final String? nbJeton;

  TombolaNewState({
    this.status = TombolaNewStatus.initial,
    this.formKey,
    this.errorMessage,
    this.kermesse,
    this.actor,
    this.nbJeton
  });

  TombolaNewState copyWith({
    TombolaNewStatus? status,
    GlobalKey<FormState>? formKey,
    String? errorMessage,
    Kermesse? kermesse,
    Actor? actor,
    String? nbJeton,
  }) {
    return TombolaNewState(
      status: status ?? this.status,
      formKey: formKey,
      errorMessage: errorMessage ?? this.errorMessage,
      kermesse: kermesse ?? this.kermesse,
      actor: actor ?? this.actor,
      nbJeton: nbJeton ?? this.nbJeton,
    );
  }
}