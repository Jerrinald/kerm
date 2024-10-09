part of 'my_account_bloc.dart';


enum MyAccountStatus { initial, loading, success, error }

class MyAccountState {
  final MyAccountStatus status;
  final User? user;
  final String? role;
  final List<User>? kids;
  final String? errorMessage;

  MyAccountState({
    this.status = MyAccountStatus.initial,
    this.user,
    this.role,
    this.kids,
    this.errorMessage,
  });

  MyAccountState copyWith({
    MyAccountStatus? status,
    User? user,
    String? role,
    List<User>? kids,
    String? errorMessage,
  }) {
    return MyAccountState(
      status: status ?? this.status,
      user: user ?? this.user,
      role: role ?? this.role,
      kids: kids ?? this.kids,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}