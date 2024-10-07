part of 'kermesse_show_bloc.dart';

enum KermesseShowStatus { initial, loading, success, error }

class KermesseShowState {
  final KermesseShowStatus status;
  final Kermesse? kermesse;
  final Stand? stand;
  final List<Stand>? stands;
  final String? role;
  final Actor? actor;
  final String? errorMessage;

  KermesseShowState({
    this.status = KermesseShowStatus.initial,
    this.kermesse,
    this.stand,
    this.stands,
    this.role,
    this.actor,
    this.errorMessage,
  });

  KermesseShowState copyWith({
    KermesseShowStatus? status,
    Kermesse? kermesse,
    Stand? stand,
    List<Stand>? stands,
    String? role,
    Actor? actor,
    String? errorMessage,
  }) {
    return KermesseShowState(
      status: status ?? this.status,
      kermesse: kermesse ?? this.kermesse,
      stand: stand ?? this.stand,
      stands: stands ?? this.stands,
      role: role ?? this.role,
      actor: actor ?? this.actor,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}