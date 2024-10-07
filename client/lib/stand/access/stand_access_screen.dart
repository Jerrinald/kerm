import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/home/home_screen.dart';
import 'package:flutter_flash_event/stand/access/bloc/stand_access_bloc.dart';
import 'package:flutter_flash_event/stand/show/stand_show_screen.dart';
import 'package:intl/intl.dart';

class StandAccessScreen extends StatelessWidget {
  static const String routeName = '/stand-access';

  static navigateTo(BuildContext context, {required int id}) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  final int id;

  const StandAccessScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<StandAccessBloc>(context);
    int counter = 0; // Counter for nbJeton

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acheter ou participer'),
      ),
      body: BlocBuilder<StandAccessBloc, StandAccessState>(
        builder: (context, state) {
          // Show loading if stand is not yet loaded
          if (state.stand == null) {
            return const Center(
              child: CircularProgressIndicator(), // Loading state
            );
          }

          // Always display the stand name
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the stand name
                Text(
                  'Stand: ${state.stand!.name}', // Stand name always displayed
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Check the stand type and render the appropriate UI
                if (state.stand!.type == 'drink' || state.stand!.type == 'food')
                  Column(
                    children: [
                      const Text('Quantité:', style: TextStyle(fontSize: 16)),
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
                      const SizedBox(height: 16),

                      if (state.nbJeton! >= counter)
                        const Text(
                          "Vous n'avez pas assez de jeton",
                          style: TextStyle(fontSize: 24),
                        ),

                      // Show ElevatedButton only if counter > 0
                      if (counter > 0 && state.nbJeton! >= counter)
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<StandAccessBloc>(context).add(SubmitFormEvent(
                              onSuccess: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$counter ${counter == 1 ? 'jeton' : 'jetons'} dépensés')), // Removed 'const'
                                );
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
                          child: Text('Dépenser $counter ${counter == 1 ? 'jeton' : 'jetons'}'),
                        ),
                    ],
                  )
                else if (state.stand!.type == 'activity')
                  const Center(
                    child: Text('Activity mode: Press the button below to run the activity'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<StandAccessBloc>(context).add(
                          ActivityGameEvent(
                            id: id,
                            onSuccess: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Congratulations, you won the game!')),
                              );
                            },
                            onLose: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sorry, you lost the game.')),
                              );
                            },
                            onError: (errorMessage) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            },
                        ));
                      },
                      child: const Text('Créer le stand'),
                    ),
              ],
            ),
          );
        },
      ),

    );
  }
}