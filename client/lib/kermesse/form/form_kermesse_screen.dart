import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/home/home_screen.dart';
import 'package:flutter_flash_event/kermesse/form/bloc/form_kermesse_bloc.dart';
import 'package:flutter_flash_event/myAccount/my_account_screen.dart';
import 'package:intl/intl.dart';

class FormKermesseScreen extends StatelessWidget {
  static const String routeName = '/new_kermesse';

  static navigateTo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => FormKermesseBloc(),
          child: const FormKermesseScreen(),
        ),
      ),
    );
  }

  const FormKermesseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<FormKermesseBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organiser une kermesse'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nom'),
              onChanged: (value) {
                // Dispatch event to validate form when the username changes
                formBloc.add(ValidateFormEvent(name: value));
              },
            ),

            SizedBox(height: 20),
            BlocBuilder<FormKermesseBloc, FormKermesseState>(
              builder: (context, state) {
                if (state.status == FormStatus.success) {
                  return Text('Form is valid!');
                } else if (state.status == FormStatus.error) {
                  return Text(state.errorMessage!);
                } else {
                  return Container(); // Initial state
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<FormKermesseBloc>(context).add(SubmitFormEvent(
                  onSuccess: () {
                    HomeScreen.navigateTo(context);
                  },
                  onError: (errorMessage) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  },
                ));
              },
              child: const Text('Créer l\'événement'),
            ),
          ],
        ),
      ),
    );
  }

}

