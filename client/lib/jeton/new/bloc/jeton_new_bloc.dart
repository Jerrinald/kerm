import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';
import 'package:flutter_flash_event/core/models/actor.dart';
import 'package:flutter_flash_event/core/models/kermesse.go.dart';
import 'package:flutter_flash_event/core/services/actor_services.dart';
import 'package:flutter_flash_event/core/services/kermesse_services.dart';
import 'package:flutter_flash_event/core/services/paiement_services.dart';
import 'package:flutter_flash_event/core/services/stand_services.dart';

part 'jeton_new_event.dart';
part 'jeton_new_state.dart';

class JetonNewBloc extends Bloc<JetonNewEvent, JetonNewState> {
  JetonNewBloc() : super(JetonNewState()) {
    final formKey = GlobalKey<FormState>();


    on<EventDataLoaded>((event, emit) async {
      emit(state.copyWith(status: JetonNewStatus.loading));

      try {
        final kermesse = await KermesseServices.getKermesseById(id: event.id);
          // Emit state when there is no stand but still check user role
        emit(state.copyWith(
          status: JetonNewStatus.success,
          kermesse: kermesse,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(status: JetonNewStatus.error,
            errorMessage: 'An error occurred: ${error.message}'));
      }
    });

    on<ValidateFormEvent>((event, Emitter<JetonNewState> emit) async {
      // Perform form validation logic here
      // Example: Check if the username and password are valid
      if (int.parse(event.nbJeton) > 0) {
        emit(state.copyWith(
            status: JetonNewStatus.success,
            nbJeton: event.nbJeton
        ));
      } else {
        emit(state.copyWith(
          status: JetonNewStatus.error,
          errorMessage: 'Donnée invalide',
        ));
      }
    });

    on<SubmitFormEvent>((event,  Emitter<JetonNewState> emit) async {
      emit(state.copyWith(status: JetonNewStatus.loading));

      final actor = await ActorServices.getMyActor(id: event.id);
      print(int.parse(state.nbJeton!));

      Actor actorReq = Actor(
          id: actor!.id,
          userId: 0,
          kermesseId: event.id,
          nbJeton: int.parse(state.nbJeton!),
          response: false,
          active: false
      );
      try {
        final response = await ActorServices.updateActorJetonById(actorReq);
        if (response.statusCode == 201 || response.statusCode == 200) {
          event.onSuccess();
        } else {
          event.onError('Jeton update failed');
        }
      } on ApiException catch (error) {
        event.onError('Probleme lors du update: ${error.message}');
      }

    });

    /*on<SubmitFormEvent>((event,  Emitter<JetonNewState> emit) async {
      emit(state.copyWith(status: JetonNewStatus.loading));
      try {

        int nbJeton = int.parse(state.nbJeton!);
        final clientSecret = await PaiementServices.getPaiement(nbJeton: nbJeton);
        await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.light,
          merchantDisplayName: 'Your App Name',
        ));

        await Stripe.instance.presentPaymentSheet();

        Actor actorReq = Actor(
            id: actor!.id,
            userId: 0,
            kermesseId: event.id,
            nbJeton: int.parse(state.nbJeton!),
            response: false,
            active: false
        );
        final jetonResponse = await ActorServices.updateActorJetonById(actorReq);
        if (jetonResponse.statusCode == 201 || jetonResponse.statusCode == 200) {
          event.onSuccess();
        } else {
          event.onError('Jeton update failed');
        }

      } on StripeException catch (e) {
        event.onError('Payment failed: ${e.error.localizedMessage}');
      } catch (error) {
        event.onError('Probleme lors du update: $error');
      }
    });*/

  }
}