import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';
import 'package:flutter_flash_event/core/models/kermesse.go.dart';
import 'package:flutter_flash_event/core/models/stand.dart';

import 'package:flutter_flash_event/core/services/kermesse_services.dart';
import 'package:flutter_flash_event/core/services/stand_services.dart';
import 'package:flutter_flash_event/core/services/user_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_flash_event/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'stand_show_event.dart';
part 'stand_show_state.dart';

class StandShowBloc extends Bloc<StandShowEvent, StandShowState> {
  StandShowBloc() : super(StandShowState()) {
    final formKey = GlobalKey<FormState>();

    on<StandDataLoaded>((event, emit) async {
      emit(state.copyWith(status: StandShowStatus.loading));

      try {

        final stand = await StandServices.getStandById(id: event.id);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? role = prefs.getString('role');

        emit(state.copyWith(
          status: StandShowStatus.success,
          stand: stand,
          role: role
        ));


      } on ApiException catch (error) {
        emit(state.copyWith(status: StandShowStatus.error,
            errorMessage: 'An error occurred: ${error.message}'));
      }
    });


  }
}