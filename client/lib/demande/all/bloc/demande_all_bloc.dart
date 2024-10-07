import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';
import 'package:flutter_flash_event/core/models/actor.dart';
import 'package:flutter_flash_event/core/services/actor_services.dart';

import 'package:flutter_flash_event/core/services/kermesse_services.dart';
import 'package:flutter_flash_event/core/services/stand_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'demande_all_event.dart';
part 'demande_all_state.dart';

class DemandeAllBloc extends Bloc<DemandeAllEvent, DemandeAllState> {
  DemandeAllBloc() : super(DemandeAllState()) {
    final formKey = GlobalKey<FormState>();

    on<ActorsDataLoaded>((event, emit) async {
      emit(state.copyWith(status: DemandeAllStatus.loading));
      try {

        final actors = await ActorServices.getActorWithMyKermesses();

        // Emit state when there is no stand but still check user role
        emit(state.copyWith(
            status: DemandeAllStatus.success,
            actors: actors
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(status: DemandeAllStatus.error,
            errorMessage: 'An error occurred: ${error.message}'));
      }
    });


    on<UpdateActorEvent>((event,  Emitter<DemandeAllState> emit) async {
      emit(state.copyWith(status: DemandeAllStatus.loading));


      Actor actorReq = Actor(
        id: event.id,
        userId: 0,
        kermesseId: 0,
        nbJeton: 0,
        response: true,
        active: event.active,
      );
      try {
        final response = await ActorServices.updateActorActiveById(actorReq);
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