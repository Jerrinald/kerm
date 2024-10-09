
import 'package:flutter/foundation.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/core/models/kermesse.go.dart';
import 'package:flutter_flash_event/core/services/api_services.dart';
import 'package:flutter_flash_event/core/services/kermesse_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {

    on<HomeDataLoaded>((event, emit) async {
      emit(HomeLoading());
      try {
        final myKermesses = await KermesseServices.getMyKermesses();
        final allKermesses = await KermesseServices.getKermesses();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? role = prefs.getString('role');

        print('Error: ${myKermesses.length}');
        emit(HomeDataLoadSuccess(
            myKermesses: myKermesses,
                allKermesses: allKermesses,
          role: role!
        ));
      } on ApiException catch (error) {
        emit(HomeDataLoadError(errorMessage: 'An error occurred.'));
      }
    });
  }

}


