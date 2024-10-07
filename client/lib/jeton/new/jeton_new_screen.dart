import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/home/home_screen.dart';
import 'package:flutter_flash_event/jeton/new/bloc/jeton_new_bloc.dart';
import 'package:flutter_flash_event/kermesse/show/kermesse_show_screen.dart';
import 'package:flutter_flash_event/stand/show/stand_show_screen.dart';
import 'package:intl/intl.dart';

class JetonNewScreen extends StatelessWidget {
  static const String routeName = '/new-jeton';

  static navigateTo(BuildContext context, {required int id}) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  final int id;

  const JetonNewScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<JetonNewBloc>(context);
    int counter = 0; // Counter for nbJeton

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acheter des jetons'),
      ),
      body: BlocBuilder<JetonNewBloc, JetonNewState>(
        builder: (context, state) {
          // Always display the stand name
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the stand name
                Text(
                  'kermesse: ${state.kermesse!.name}', // Stand name always displayed
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                  Column(
                    children: [
                      const Text('Nombre de jetons:', style: TextStyle(fontSize: 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (counter > 0) {
                                counter--;
                                formBloc.add(ValidateFormEvent(nbJeton: counter.toString()));
                              }
                            },
                          ),
                          Text(
                            counter.toString(),
                            style: const TextStyle(fontSize: 24),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              counter++;
                              formBloc.add(ValidateFormEvent(nbJeton: counter.toString()));
                            },
                          ),
                        ],
                      ),

                      if (counter > 0)
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<JetonNewBloc>(context).add(SubmitFormEvent(
                              onSuccess: () {
                                  KermesseShowScreen.navigateTo(context, id: id);
                              },
                              onError: (errorMessage) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMessage)),
                                );
                              },
                              id: id,
                            ));
                          },
                          // Dynamically display the button text based on counter
                          child: Text('Dépenser $counter ${counter == 1 ? 'euro' : 'euros'}'),
                        ),
                    ],
                  )
              ],
            ),
          );
        },
      ),

    );
  }
}