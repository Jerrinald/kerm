import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/home/home_screen.dart';
import 'package:flutter_flash_event/jeton/new/bloc/jeton_new_bloc.dart';
import 'package:flutter_flash_event/kermesse/show/kermesse_show_screen.dart';
import 'package:flutter_flash_event/stand/show/stand_show_screen.dart';
import 'package:intl/intl.dart';

class JetonNewScreen extends StatelessWidget {
  static const String routeName = '/new-jeton';

  // Method to navigate to the JetonNewScreen with the BlocProvider
  static navigateTo(BuildContext context, {required int id}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider<JetonNewBloc>(
          create: (context) {
            final bloc = JetonNewBloc();  // Create the JetonNewBloc instance
            bloc.add(EventDataLoaded(id: id)); // Trigger EventDataLoaded when the screen loads
            return bloc;
          },
          child: JetonNewScreen(id: id),
        ),
      ),
    );
  }

  final int id;

  const JetonNewScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    int counter = 0; // Counter for nbJeton
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acheter des jetons'),
      ),
      // Use the BlocBuilder to access the state of JetonNewBloc
      body: BlocBuilder<JetonNewBloc, JetonNewState>(
        builder: (context, state) {
          if (state.status == JetonNewStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == JetonNewStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          if (state.kermesse == null) {
            return const Center(child: Text('No Kermesse data available'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the kermesse name
                Text(
                  'Kermesse: ${state.kermesse!.name}',
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
                              context.read<JetonNewBloc>().add(ValidateFormEvent(nbJeton: counter.toString()));
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
                            context.read<JetonNewBloc>().add(ValidateFormEvent(nbJeton: counter.toString()));
                          },
                        ),
                      ],
                    ),
                    if (counter > 0)
                      ElevatedButton(
                        onPressed: () {
                          context.read<JetonNewBloc>().add(SubmitFormEvent(
                            onSuccess: () {
                              // Handle success
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
                        child: Text('Dépenser $counter ${counter == 1 ? 'euro' : 'euros'}'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
