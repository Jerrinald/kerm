import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';
import 'package:flutter_flash_event/core/models/stand.dart';
import 'package:flutter_flash_event/core/services/stand_services.dart';
import 'package:flutter_flash_event/utils/extensions.dart';


part 'form_stand_event.dart';
part 'form_stand_state.dart';

class FormStandBloc extends Bloc<FormStandEvent, FormStandState> {
  FormStandBloc() : super(FormStandState()) {
    final formKey = GlobalKey<FormState>();


    on<ValidateFormEvent>((event, Emitter<FormStandState> emit) async {
      // Perform form validation logic here
      // Example: Check if the username and password are valid
      if (!event.isSubmit) {
        String? type = event.type.isNotEmpty ? event.type : state.type;
        String? name = event.name.isNotEmpty ? event.name : state.name;
        emit(state.copyWith(
            status: FormStatus.success,
            type: type,
            maxPoint: event.maxPoint,
            name: name
        ));
      }
      else {
        if (state.type!.isNotEmpty && state.name!.isNotEmpty) {
          emit(state.copyWith(
              status: FormStatus.success,
              type: state.type,
              maxPoint: event.maxPoint,
              name: state.name
          ));
        } else {
          emit(state.copyWith(
            status: FormStatus.error,
            errorMessage: 'Donnée invalide',
          ));
        }
      }


    });

    on<SubmitFormEvent>((event,  Emitter<FormStandState> emit) async {
      emit(state.copyWith(status: FormStatus.loading));
      Stand stand = Stand(
          id: 0,
          actorId: 0,
          kermesseId: event.id,
          type: state.type!,
          maxPoint:  0,
          name: state.name!
      );

      try {
        final response = await StandServices.addStand(stand);
        print('${response}  oui oui');
        if (response.statusCode == 201) {
          print('${event.id}  oui oui');
          event.onSuccess();
        } else {
          print('${event.id}  oui oui');
          event.onError('Probleme lors de la création du stand');
        }
      } on ApiException catch (error) {
        print('${event.id}  oui oui');
        event.onError('Probleme lors de la création: ${error.message}');
      }

    });
  }
}