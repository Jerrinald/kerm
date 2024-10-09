part of 'stock_bloc.dart';

@immutable
sealed class StockEvent {}

class StockLoaded extends StockEvent {
  final int id;

  StockLoaded({required this.id});
}

class ValidateFormEvent extends StockEvent {
  final String stock;

  ValidateFormEvent({required this.stock});
}

class SubmitEvent extends StockEvent {
  final int id;
  final String stock;
  final VoidCallback onSuccess;
  final Function(String) onError;

  @override
  List<Object> get props => [onSuccess, onError, id, stock];

  SubmitEvent({required this.id, required this.stock, required this.onError,
  required this.onSuccess});
}
