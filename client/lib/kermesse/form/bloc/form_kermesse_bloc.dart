import 'package:flutter/cupertino.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';

import 'package:flutter_flash_event/core/models/kermesse.go.dart';
import 'package:flutter_flash_event/core/models/user.dart';
import 'package:flutter_flash_event/core/services/kermesse_services.dart';
import 'package:flutter_flash_event/core/services/user_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'form_kermesse_event.dart';
part 'form_kermesse_state.dart';

class FormKermesseBloc extends Bloc<FormKermesseEvent, FormKermesseState> {
  FormKermesseBloc() : super(FormKermesseState()) {
    final formKey = GlobalKey<FormState>();

    on<ValidateFormEvent>((event,  Emitter<FormKermesseState> emit) async {
        // Perform form validation logic here
        // Example: Check if the username and password are valid
        if (event.name.isValidName) {
          emit(state.copyWith(
            status: FormStatus.success,
            name: event.name
          ));
        } else {
          emit(state.copyWith(
            status: FormStatus.error,
            errorMessage: 'Donnée invalide',
          ));
        }
    });

    on<SubmitFormEvent>((event,  Emitter<FormKermesseState> emit) async {
      emit(state.copyWith(status: FormStatus.loading));
      print('Error: ${state.name}');
      Kermesse kermesse = Kermesse(
        id: 0,
        name: state.name!,
      );
      try {
        final response = await KermesseServices.addKermesse(kermesse);
        if (response.statusCode == 201) {
          event.onSuccess();
        } else {
          event.onError('Event creation failed');
        }
      } on ApiException catch (error) {
        event.onError('Probleme lors de la création: ${error.message}');
      }

    });
  }
}