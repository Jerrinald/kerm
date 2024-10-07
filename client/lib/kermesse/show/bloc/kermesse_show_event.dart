part of 'kermesse_show_bloc.dart';

@immutable
sealed class KermesseShowEvent {}

class KermesseDataLoaded extends KermesseShowEvent {
  final int id;

  KermesseDataLoaded({required this.id});
}

class SubmitFormEvent extends KermesseShowEvent {
  SubmitFormEvent({required this.onSuccess, required this.onError, required this.id});

  final int id;

  final VoidCallback onSuccess;
  final Function(String) onError;

  @override
  List<Object> get props => [onSuccess, onError, id];
}