import 'package:flutter/cupertino.dart';
import 'package:flutter_flash_event/core/exceptions/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/core/models/user.dart';
import 'package:flutter_flash_event/core/services/auth_services.dart';
import 'package:flutter_flash_event/core/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'my_account_event.dart';
part 'my_account_state.dart';

class MyAccountBloc extends Bloc<MyAccountEvent, MyAccountState> {
  MyAccountBloc() : super(MyAccountState()) {
    on<MyAccountDataLoaded>((event, emit) async {
      emit(state.copyWith(status: MyAccountStatus.loading));

      try {
        final user = await UserServices.getCurrentUser();

        final kids = await UserServices.getUsersWiThParent();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? role = prefs.getString('role');

        print(role);

        emit(state.copyWith(status: MyAccountStatus.success,
            user: user,
            role: role,
          kids: kids
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(status: MyAccountStatus.error, errorMessage: 'An error occurred'));
      }
    });

    on<MyAccountLogout>((event, emit) async {
      emit(state.copyWith(status: MyAccountStatus.loading));

      try {
        await AuthServices.logoutUser();
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('email');
        await prefs.remove('userId');
        await prefs.remove('role');
        emit(state.copyWith(status: MyAccountStatus.success));

        // Call the success callback
        event.success();
      } on ApiException catch (error) {
        emit(state.copyWith(status: MyAccountStatus.error, errorMessage: 'An error occurred'));

        // Call the error callback with the error message
        event.error('Logout failed. Please try again.');
      }
    });
  }
}