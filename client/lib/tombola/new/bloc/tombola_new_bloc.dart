import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';
import 'package:flutter_flash_event/core/models/actor.dart';
import 'package:flutter_flash_event/core/models/kermesse.go.dart';
import 'package:flutter_flash_event/core/models/tombola.dart';
import 'package:flutter_flash_event/core/services/actor_services.dart';
import 'package:flutter_flash_event/core/services/kermesse_services.dart';
import 'package:flutter_flash_event/core/services/stand_services.dart';
import 'package:flutter_flash_event/core/services/tombola_services.dart';

part 'tombola_new_event.dart';
part 'tombola_new_state.dart';

class TombolaNewBloc extends Bloc<TombolaNewEvent, TombolaNewState> {
  TombolaNewBloc() : super(TombolaNewState()) {
    final formKey = GlobalKey<FormState>();


    on<EventDataLoaded>((event, emit) async {
      emit(state.copyWith(status: TombolaNewStatus.loading));

      try {
        final kermesse = await KermesseServices.getKermesseById(id: event.id);
        print(kermesse);
        // Emit state when there is no stand but still check user role
        emit(state.copyWith(
          status: TombolaNewStatus.success,
          kermesse: kermesse,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(status: TombolaNewStatus.error,
            errorMessage: 'An error occurred: ${error.message}'));
      }
    });

    on<ValidateFormEvent>((event, Emitter<TombolaNewState> emit) async {
      // Perform form validation logic here
      // Example: Check if the username and password are valid
      if (int.parse(event.nbJeton) > 0) {
        emit(state.copyWith(
            status: TombolaNewStatus.success,
            nbJeton: event.nbJeton
        ));
      }
    });

    on<SubmitFormEvent>((event,  Emitter<TombolaNewState> emit) async {
      emit(state.copyWith(status: TombolaNewStatus.loading));

      Tombola tombola = Tombola(
          id: 0,
          actorId: 0,
          kermesseId: event.id,
          nbTicket: int.parse(state.nbJeton!),
      );
      try {
        final response = await TombolaServices.addTicket(tombola);
        if (response.statusCode == 201 || response.statusCode == 200) {
          event.onSuccess();
        } else {
          event.onError('Jeton update failed');
        }
      } on ApiException catch (error) {
        event.onError('Probleme lors du update: ${error.message}');
      }

    });
  }
}