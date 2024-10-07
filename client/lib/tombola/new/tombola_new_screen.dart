import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/kermesse/show/kermesse_show_screen.dart';
import 'package:flutter_flash_event/tombola/new/bloc/tombola_new_bloc.dart';
import 'package:intl/intl.dart';

class TombolaNewScreen extends StatelessWidget {
  static const String routeName = '/new-ticket';

  static navigateTo(BuildContext context, {required int id}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TombolaNewBloc()..add(EventDataLoaded(id: id)), // Initialize the event data
          child: TombolaNewScreen(id: id),
        ),
      ),
    );
  }

  final int id;

  const TombolaNewScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<TombolaNewBloc>(context);
    int counter = 0; // Counter for nbJeton

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acheter des tickets de tombola'),
      ),
      body: BlocBuilder<TombolaNewBloc, TombolaNewState>(
        builder: (context, state) {
          if (state.status == TombolaNewStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == TombolaNewStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'An error occurred'));
          } else if (state.status == TombolaNewStatus.success) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the stand name
                  Text(
                    '${state.kermesse?.name ?? 'Unknown'}', // Stand name always displayed
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Column(
                    children: [
                      const Text('Nombre de tickets:', style: TextStyle(fontSize: 16)),
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
                            BlocProvider.of<TombolaNewBloc>(context).add(SubmitFormEvent(
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
          }

          return Container(); // Default case
        },
      ),
    );
  }
}
