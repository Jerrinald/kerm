// new_kid_event.dart
part of 'new_kid_bloc.dart';

abstract class NewKidEvent {}

class SubmitFormEvent extends NewKidEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final VoidCallback onSuccess;
  final Function(String) onError;

  SubmitFormEvent({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    required this.onSuccess,
    required this.onError,
  });
}

