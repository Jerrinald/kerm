// new_kid_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_flash_event/core/models/user.dart';
import 'package:flutter_flash_event/core/services/auth_services.dart';


part 'new_kid_event.dart';
part 'new_kid_state.dart';

class NewKidBloc extends Bloc<NewKidEvent, NewKidState> {
  NewKidBloc() : super(const NewKidState()) {


    on<SubmitFormEvent>((event,  Emitter<NewKidState> emit) async  {
      emit(state.copyWith(status: FormStatus.loading));

      // Create a new User object
      User newUser = User(
        firstname: event.firstName,
        lastname: event.lastName,
        username: event.username,
        email: event.email,
        password: event.password,
        id: 0,
        role: 'eleve',
        parentId: 0, // Update role as necessary
      );

      try {
        // Make the request to register the user
        final response = await AuthServices.registerKid(newUser);

        if (response.statusCode == 201) {
          // On success
          emit(state.copyWith(status: FormStatus.success));
          event.onSuccess();
        } else {
          // On error
          final errorMessage = 'Échec de l\'inscription';
          emit(state.copyWith(status: FormStatus.error, errorMessage: errorMessage));
          event.onError(errorMessage);
        }
      } catch (e) {
        // On exception
        final errorMessage = 'Erreur: $e';
        emit(state.copyWith(status: FormStatus.error, errorMessage: errorMessage));
        event.onError(errorMessage);
      }
    });
  }

}
