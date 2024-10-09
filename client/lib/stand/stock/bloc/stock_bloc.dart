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

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  StockBloc() : super(StockState()) {
    final formKey = GlobalKey<FormState>();

    on<StockLoaded>((event, emit) async {
      emit(state.copyWith(status: StockStatus.loading));

      try {

        print(event.id);

        final stand = await StandServices.getStandById(id: event.id);
        print(stand.type);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? role = prefs.getString('role');

        emit(state.copyWith(
            status: StockStatus.success,
            stand: stand,
            role: role
        ));


      } on ApiException catch (error) {
        emit(state.copyWith(status: StockStatus.error,
            errorMessage: 'An error occurred: ${error.message}'));
      }
    });

    on<ValidateFormEvent>((event, Emitter<StockState> emit) async {
      // Perform form validation logic here
      // Example: Check if the username and password are valid
      if (int.parse(event.stock) > 0) {
        emit(state.copyWith(
          status: StockStatus.success,
          stock: int.parse(event.stock),
        ));
      } else {
        emit(state.copyWith(
          status: StockStatus.error,
          errorMessage: 'Donnée invalide',
        ));
      }
    });

    on<SubmitEvent>((event,  Emitter<StockState> emit) async {
      emit(state.copyWith(status: StockStatus.loading));
      Stand stand = Stand(
        id: event.id,
        actorId: 0,
        stock: state.stock!,
        kermesseId: 0,
        type: '',
        name: '',
        maxPoint: 0,
      );

      try {
        final response = await StandServices.updateStandrById(stand);
        if (response.statusCode == 201 || response.statusCode == 200) {
          event.onSuccess();
        } else {
          event.onError('Stat Stand creation failed');
        }
      } on ApiException catch (error) {
        event.onError('Probleme lors de la création: ${error.message}');
      }

    });


  }
}