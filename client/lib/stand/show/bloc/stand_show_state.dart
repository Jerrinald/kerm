part of 'stand_show_bloc.dart';

enum StandShowStatus { initial, loading, success, error }

class StandShowState {
  final StandShowStatus status;
  final Stand? stand;
  final String? role;
  final String? errorMessage;

  StandShowState({
    this.status = StandShowStatus.initial,
    this.stand,
    this.role,
    this.errorMessage,
  });

  StandShowState copyWith({
    StandShowStatus? status,
    Stand? stand,
    String? role,
    String? errorMessage,
  }) {
    return StandShowState(
      status: status ?? this.status,
      stand: stand ?? this.stand,
      role: role ?? this.role,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}