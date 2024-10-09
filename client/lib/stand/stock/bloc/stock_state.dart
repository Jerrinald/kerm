part of 'stock_bloc.dart';

enum StockStatus { initial, loading, success, error }

class StockState {
  final StockStatus status;
  final Stand? stand;
  final String? role;
  final int? stock;
  final String? errorMessage;

  StockState({
    this.status = StockStatus.initial,
    this.stand,
    this.role,
    this.stock,
    this.errorMessage,
  });

  StockState copyWith({
    StockStatus? status,
    Stand? stand,
    String? role,
    int? stock,
    String? errorMessage,
  }) {
    return StockState(
      status: status ?? this.status,
      stand: stand ?? this.stand,
      role: role ?? this.role,
      stock: stock ?? this.stock,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}