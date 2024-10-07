import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/home/home_screen.dart';
import 'package:flutter_flash_event/kermesse/show/kermesse_show_screen.dart';
import 'package:flutter_flash_event/myAccount/my_account_screen.dart';
import 'package:flutter_flash_event/stand/form/bloc/form_stand_bloc.dart';
import 'package:intl/intl.dart';

class FormStandScreen extends StatelessWidget {
  static const String routeName = '/new-stand';

  static navigateTo(BuildContext context, {required int id}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => FormStandBloc(), // Provide the FormStandBloc here
          child: FormStandScreen(id: id),
        ),
      ),
    );
  }

  final int id;

  const FormStandScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<FormStandBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenir un stand'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Type'),
              items: const [
                DropdownMenuItem(
                  value: 'drink',
                  child: Text('Boisson'),
                ),
                DropdownMenuItem(
                  value: 'food',
                  child: Text('Nourriture'),
                ),
                DropdownMenuItem(
                  value: 'activity',
                  child: Text('Activité'),
                ),
              ],
              onChanged: (value) {
                // Dispatch event to validate form when the type changes
                formBloc.add(ValidateFormEvent(name: '', type: value!, maxPoint: '', isSubmit: false));
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nom'),
              onChanged: (value) {
                // Dispatch event to validate form when the username changes
                formBloc.add(ValidateFormEvent(type: '', maxPoint: '', name: value, isSubmit: false));
              },
            ),

            SizedBox(height: 20),
            BlocBuilder<FormStandBloc, FormStandState>(
              builder: (context, state) {
                if (state.status == FormStatus.success) {
                  return Text('');
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
                BlocProvider.of<FormStandBloc>(context).add(SubmitFormEvent(
                  onSuccess: () {
                    KermesseShowScreen.navigateTo(context, id: id);
                  },
                  onError: (errorMessage) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }, id: id,
                ));
              },
              child: const Text('Créer le stand'),
            ),
          ],
        ),
      ),
    );
  }

}

