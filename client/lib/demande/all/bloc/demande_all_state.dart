part of 'demande_all_bloc.dart';

enum DemandeAllStatus { initial, loading, success, error }

class DemandeAllState {
  final DemandeAllStatus status;
  final List<ActorUser>? actors;
  final String? errorMessage;

  DemandeAllState({
    this.status = DemandeAllStatus.initial,
    this.actors,
    this.errorMessage,
  });

  DemandeAllState copyWith({
    DemandeAllStatus? status,
    List<ActorUser>? actors,
    String? errorMessage,
  }) {
    return DemandeAllState(
      status: status ?? this.status,
      actors: actors ?? this.actors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}