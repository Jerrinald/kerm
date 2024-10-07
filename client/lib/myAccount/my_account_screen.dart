import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/myAccount/bloc/my_account_bloc.dart';
import 'package:flutter_flash_event/core/services/auth_services.dart';
import 'package:flutter_flash_event/login/login_screen.dart';

class MyAccountScreen extends StatelessWidget {
  static const String routeName = '/my-account';

  static navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const MyAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyAccountBloc()..add(MyAccountDataLoaded()),
      child: BlocBuilder<MyAccountBloc, MyAccountState>(
        builder: (context, state) {
          final user = state.user;
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF9F9F9),
              appBar: AppBar(
                title: const Text('Mon compte'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                ],
              ),
              body:  Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6058E9), // Same color as login button
                          foregroundColor: Colors.white, // White text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        ),
                        onPressed:  () {
                          BlocProvider.of<MyAccountBloc>(context).add(MyAccountLogout(
                            success: () {
                              LoginScreen.navigateTo(context);
                            },
                            error: (errorMessage) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            },
                          ));
                        },
                        child: const Text('Déconnexion'),
                      ),
                    ),
                  ],
                ),
              )
            ),
          );
        },
      ),
    );
  }
}
