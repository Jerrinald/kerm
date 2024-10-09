import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/myAccount/bloc/my_account_bloc.dart';
import 'package:flutter_flash_event/core/services/auth_services.dart';
import 'package:flutter_flash_event/login/login_screen.dart';
import 'package:flutter_flash_event/myAccount/newKid/new_kid_screen.dart';

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
          final role = state.role; // Get the role from the state
          final kids = state.kids; // Get the kids from the state

          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF9F9F9),
              appBar: AppBar(
                title: const Text('Mon compte'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                actions: [

                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Conditionally show the list of kids if the role is "parent" and kids list is not empty
                    if (role == 'parent' && kids != null && kids.isNotEmpty) ...[
                      const Text(
                        'Enfants:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Display a list of kids (firstName and lastName)
                      ListView.builder(
                        shrinkWrap: true, // So it doesn't take full screen
                        itemCount: kids.length,
                        itemBuilder: (context, index) {
                          final kid = kids[index];
                          return ListTile(
                            title: Text('${kid.firstname} ${kid.lastname}'),
                          );
                        },
                      ),
                      const SizedBox(height: 20), // Add some space before the button
                    ],

                    // Conditionally show the "Inscrire un enfant" button if the role is "parent"
                    if (role == 'parent') ...[
                      const Spacer(), // Pushes the button to the center vertically
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Set any color for the new button
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          ),
                          onPressed: () {
                            NewKidScreen.navigateTo(context);
                          },
                          child: const Text('Inscrire un enfant'),
                        ),
                      ),
                      const Spacer(), // Adds space between the buttons
                    ],

                    // "Déconnexion" button at the bottom
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6058E9), // Same color as login button
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        ),
                        onPressed: () {
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
              ),
            ),
          );
        },
      ),
    );
  }
}

