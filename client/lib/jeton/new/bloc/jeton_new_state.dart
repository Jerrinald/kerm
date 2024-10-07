part of 'jeton_new_bloc.dart';

enum JetonNewStatus { initial, loading, success, error }

class JetonNewState {
  final JetonNewStatus status;
  final GlobalKey<FormState>? formKey;
  final String? errorMessage;
  final Kermesse? kermesse;
  final Actor? actor;
  final String? nbJeton;

  JetonNewState({
    this.status = JetonNewStatus.initial,
    this.formKey,
    this.errorMessage,
    this.kermesse,
    this.actor,
    this.nbJeton
  });

  JetonNewState copyWith({
    JetonNewStatus? status,
    GlobalKey<FormState>? formKey,
    String? errorMessage,
    Kermesse? kermesse,
    Actor? actor,
    String? nbJeton,
  }) {
    return JetonNewState(
      status: status ?? this.status,
      formKey: formKey,
      errorMessage: errorMessage ?? this.errorMessage,
      kermesse: kermesse ?? this.kermesse,
      actor: actor ?? this.actor,
      nbJeton: nbJeton ?? this.nbJeton,
    );
  }
}