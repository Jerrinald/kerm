import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/demande/all/bloc/demande_all_bloc.dart';

class DemandeAllScreen extends StatelessWidget {
  static const String routeName = '/demandes';

  static navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const DemandeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DemandeAllBloc()..add(ActorsDataLoaded()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: SafeArea(
          child: BlocBuilder<DemandeAllBloc, DemandeAllState>(
            builder: (context, state) {
              if (state.status == DemandeAllStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state.status == DemandeAllStatus.error) {
                return Center(
                  child: Text(state.errorMessage!),
                );
              }

              if (state.status == DemandeAllStatus.success) {
                final int myActorsCount = state.actors!.length;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Les demandes d\'accès',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (myActorsCount == 0)
                        const Center(
                          child: Text(
                            'Aucune demandes à afficher',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: myActorsCount,
                            itemBuilder: (context, index) {
                              final actor = state.actors![index];

                              // Check the conditions and display accordingly
                              if (actor.response == true && actor.active == true) {
                                // Display only the ID
                                return ListTile(
                                  title: Text('${actor.firstname} ${actor.lastname}'),
                                );
                              } else if (actor.response == true && actor.active == false) {
                                // Display ID with two buttons
                                return ListTile(
                                  title: Text('${actor.firstname} ${actor.lastname}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.cancel, color: Colors.red),
                                        onPressed: () {
                                          BlocProvider.of<DemandeAllBloc>(context).add(UpdateActorEvent(
                                            onSuccess: () {
                                              DemandeAllScreen.navigateTo(context);
                                            },
                                            onError: (errorMessage) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(errorMessage)),
                                              );
                                            },
                                            id: actor.id,
                                            active: false,
                                          ));
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.check, color: Colors.green),
                                        onPressed: () {
                                          BlocProvider.of<DemandeAllBloc>(context).add(UpdateActorEvent(
                                            onSuccess: () {
                                              DemandeAllScreen.navigateTo(context);
                                            },
                                            onError: (errorMessage) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(errorMessage)),
                                              );
                                            },
                                            id: actor.id,
                                            active: true,
                                          ));
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }

                              // Return empty container if conditions are not met
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
