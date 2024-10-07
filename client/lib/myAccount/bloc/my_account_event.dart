part of 'my_account_bloc.dart';

@immutable
sealed class MyAccountEvent {}

class MyAccountDataLoaded extends MyAccountEvent {}

class MyAccountLogout extends MyAccountEvent {
  final VoidCallback success;
  final Function(String) error;

  MyAccountLogout({required this.success, required this.error});
}