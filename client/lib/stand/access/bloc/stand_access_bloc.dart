import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';
import 'package:flutter_flash_event/core/models/stand.dart';
import 'package:flutter_flash_event/core/models/statStand.dart';

import 'package:flutter_flash_event/core/services/stand_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/core/services/stat_stand_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'stand_access_event.dart';
part 'stand_access_state.dart';

class StandAccessBloc extends Bloc<StandAccessEvent, StandAccessState> {
  StandAccessBloc() : super(StandAccessState()) {
    final formKey = GlobalKey<FormState>();

    on<StandAccessDataLoaded>((event, emit) async {
      emit(state.copyWith(status: StandAccessStatus.loading));

      try {

        final stand = await StandServices.getStandById(id: event.id);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? nbJeton = prefs.getInt('nbJeton');

        print(nbJeton);

        emit(state.copyWith(
            status: StandAccessStatus.success,
            stand: stand,
            nbJeton: nbJeton
        ));


      } on ApiException catch (error) {
        emit(state.copyWith(status: StandAccessStatus.error,
            errorMessage: 'An error occurred: ${error.message}'));
      }
    });

    on<ValidateFormEvent>((event, Emitter<StandAccessState> emit) async {
      // Perform form validation logic here
      // Example: Check if the username and password are valid
      if (int.parse(event.nbJeton) > 0) {
        emit(state.copyWith(
            status: StandAccessStatus.success,
            nbJeton: int.parse(event.nbJeton),
        ));
      } else {
        emit(state.copyWith(
          status: StandAccessStatus.error,
          errorMessage: 'Donnée invalide',
        ));
      }
    });

    on<SubmitFormEvent>((event,  Emitter<StandAccessState> emit) async {
      emit(state.copyWith(status: StandAccessStatus.loading));
      StatStand statStand = StatStand(
          id: 0,
          actorId: 0,
        standId: event.id,
        nbJeton: state.nbJeton!,
        nbPoint: 0,
      );
      try {
        final response = await StatStandServices.addStatStand(statStand);
        if (response.statusCode == 201) {
          event.onSuccess();
        } else {
          event.onError('Stat Stand creation failed');
        }
      } on ApiException catch (error) {
        event.onError('Probleme lors de la création: ${error.message}');
      }

    });

    on<ActivityGameEvent>((event, Emitter<StandAccessState> emit) async {
      emit(state.copyWith(status: StandAccessStatus.loading));

      // Simulate a 50% chance of winning or losing
      bool gameResult = Random().nextBool(); // Random true (win) or false (lose)

      // Introduce a slight delay to simulate game processing
      await Future.delayed(const Duration(seconds: 1));

      StatStand statStand = StatStand(
        id: 0,
        actorId: 0,
        standId: event.id,
        nbJeton: 1,
        nbPoint: gameResult ? 50 : 0,
      );
      try {
        final response = await StatStandServices.addStatStand(statStand);
        if (response.statusCode == 201) {
          if (gameResult) {
            // Win scenario
            emit(state.copyWith(status: StandAccessStatus.success));
            event.onSuccess(); // Call onSuccess callback
          } else {
            // Lose scenario
            emit(state.copyWith(status: StandAccessStatus.error, errorMessage: 'You lost the game.'));
            event.onLose(); // Call onLose callback
          }
        } else {
          event.onError('Stat Stand creation failed');
        }
      } on ApiException catch (error) {
        event.onError('Probleme lors de la création: ${error.message}');
      }

    });


  }
}