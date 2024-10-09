import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';
import 'package:flutter_flash_event/core/models/actor.dart';
import 'package:flutter_flash_event/core/models/kermesse.go.dart';
import 'package:flutter_flash_event/core/models/stand.dart';
import 'package:flutter_flash_event/core/services/actor_services.dart';

import 'package:flutter_flash_event/core/services/kermesse_services.dart';
import 'package:flutter_flash_event/core/services/stand_services.dart';
import 'package:flutter_flash_event/core/services/user_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_flash_event/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'kermesse_show_event.dart';
part 'kermesse_show_state.dart';

class KermesseShowBloc extends Bloc<KermesseShowEvent, KermesseShowState> {
  KermesseShowBloc() : super(KermesseShowState()) {
    final formKey = GlobalKey<FormState>();

    on<KermesseDataLoaded>((event, emit) async {
      emit(state.copyWith(status: KermesseShowStatus.loading));

      try {
        final kermesse = await KermesseServices.getKermesseById(id: event.id);

        final stands = await StandServices.getStandsByKermesse(id: event.id);

        final stand = await StandServices.getMyStand(id: event.id);

        final actor = await ActorServices.getMyActor(id: event.id);

        final actorChild = await ActorServices.getChildActorWithMyKermesses(id: event.id);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? role = prefs.getString('role');

        prefs.setInt('nbJeton', actor == null ? 0 : actor.nbJeton);

        if (stand.type != '') {
          // Emit state when the user is a stand owner and the stand exists
          emit(state.copyWith(
            status: KermesseShowStatus.success,
            kermesse: kermesse,
            stands: stands,
            stand: stand,
            actorChild: actorChild,
            role: role, // Update isStandOwner
            actor: actor
          ));
        } else {
          // Emit state when there is no stand but still check user role
          emit(state.copyWith(
            status: KermesseShowStatus.success,
            kermesse: kermesse,
            stands: stands,
            actorChild: actorChild,
            role: role,
              actor: actor
          ));
        }
      } on ApiException catch (error) {
        emit(state.copyWith(status: KermesseShowStatus.error,
            errorMessage: 'An error occurred: ${error.message}'));
      }
    });

    on<SubmitFormEvent>((event,  Emitter<KermesseShowState> emit) async {
      emit(state.copyWith(status: KermesseShowStatus.loading));

      Actor actorReq = Actor(
        id: 0,
        userId: 0,
        kermesseId: event.id,
        nbJeton: 0,
        response: false,
        active: false,
      );
      try {
        final response = await ActorServices.addActor(actorReq);
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