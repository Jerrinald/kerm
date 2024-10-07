part of 'stand_access_bloc.dart';

enum StandAccessStatus { initial, loading, success, error }

class StandAccessState {
  final StandAccessStatus status;
  final Stand? stand;
  final String? role;
  final int? nbJeton;
  final String? errorMessage;

  StandAccessState({
    this.status = StandAccessStatus.initial,
    this.stand,
    this.role,
    this.nbJeton,
    this.errorMessage,
  });

  StandAccessState copyWith({
    StandAccessStatus? status,
    Stand? stand,
    String? role,
    int? nbJeton,
    String? errorMessage,
  }) {
    return StandAccessState(
      status: status ?? this.status,
      stand: stand ?? this.stand,
      role: role ?? this.role,
      nbJeton: nbJeton ?? this.nbJeton,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}