// new_kid_state.dart
part of 'new_kid_bloc.dart';

enum FormStatus { initial, loading, success, error }

class NewKidState {
  final FormStatus status;

  final String? errorMessage;

  const NewKidState({
    this.status = FormStatus.initial,

    this.errorMessage,
  });

  NewKidState copyWith({
    FormStatus? status,

    String? errorMessage,
  }) {
    return NewKidState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

}
