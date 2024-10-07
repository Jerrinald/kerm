import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/core/models/actor.dart';
import 'package:flutter_flash_event/core/models/stand.dart';
import 'package:flutter_flash_event/home/home_screen.dart';
import 'package:flutter_flash_event/jeton/new/jeton_new_screen.dart';
import 'package:flutter_flash_event/kermesse/form/form_kermesse_screen.dart';
import 'package:flutter_flash_event/kermesse/show/bloc/kermesse_show_bloc.dart';
import 'package:flutter_flash_event/stand/form/form_stand_screen.dart';
import 'package:flutter_flash_event/stand/show/stand_show_screen.dart';
import 'package:flutter_flash_event/tombola/new/tombola_new_screen.dart';
import 'package:intl/intl.dart';

class KermesseShowScreen extends StatelessWidget {
  static const String routeName = '/kermesse-show';

  static navigateTo(BuildContext context, {required int id}) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  final int id;

  const KermesseShowScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KermesseShowBloc()..add(KermesseDataLoaded(id: id)),
      child: BlocBuilder<KermesseShowBloc, KermesseShowState>(
        builder: (context, state) {
          final kermesse = state.kermesse;
          final stands = state.stands;
          final role = state.role;
          final actor = state.actor;

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Kermesse Details'),
              ),
              body: state.status == KermesseShowStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : kermesse != null
                  ? Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${kermesse.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Display actor-specific UI based on the actor's state
                      _buildActorStatus(context, actor, stands),
                    ],
                  ),
                ),
              )
                  : const Center(child: Text("Kermesse not found")),
              // Show floating action button only when necessary
              floatingActionButton: _buildFloatingActionButton(context, actor, state, role),
            ),
          );
        },
      ),
    );
  }

  // Method to display actor status and control rendering of the stands list
  Widget _buildActorStatus(BuildContext context, Actor? actor, List<Stand>? stands) {
    if (actor == null) {
      return ElevatedButton(
        onPressed: () {
          BlocProvider.of<KermesseShowBloc>(context).add(SubmitFormEvent(
            onSuccess: () {
              HomeScreen.navigateTo(context);
            },
            onError: (errorMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
            },
            id: id,
          ));
        },
        child: const Text('Demander l\'accès'),
      );
    } else if (!actor.response && !actor.active) {


      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('En attente d\'une réponse'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              HomeScreen.navigateTo(context);
            },
            child: const Text('Retour'),
          ),
        ],
      );

    } else if (actor.response && !actor.active) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vous n\'avez pas l\'accès'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<KermesseShowBloc>(context).add(SubmitFormEvent(
                onSuccess: () {
                  HomeScreen.navigateTo(context);
                },
                onError: (errorMessage) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                },
                id: id,
              ));
            },
            child: const Text('Demander l\'accès à nouveau'),
          ),
        ],
      );
    } else {
      // If actor is active, show the list of stands
      return _buildStandsList(context, stands);
    }
  }

  // Build the list of stands
  Widget _buildStandsList(BuildContext context, List<Stand>? stands) {
    if (stands == null || stands.isEmpty) {
      return const Text("No stands available.");
    }
    return ListView.builder(
      shrinkWrap: true, // Use shrinkWrap to allow ListView inside ScrollView
      physics: const NeverScrollableScrollPhysics(), // Disable ListView's scrolling
      itemCount: stands.length,
      itemBuilder: (context, index) {
        final stand = stands[index];
        return ListTile(
          title: Text(stand.name),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            // Navigate to the StandShowScreen when tapped
            StandShowScreen.navigateTo(context, id: stand.id);
          },
        );
      },
    );
  }

  // Floating action button based on the user's role
  Widget? _buildFloatingActionButton(BuildContext context, Actor? actor, KermesseShowState state, String? role) {
    if (role == null) return null; // No FAB if role is undefined

    if (actor == null) return null;

    if (role == 'standOwner') {
      if (state.stand != null) {
        return FloatingActionButton(
          onPressed: () {
            StandShowScreen.navigateTo(context, id: state.stand!.id);
          },
          child: const Text("Voir mon stand"),
        );
      } else {
        return FloatingActionButton(
          onPressed: () {
            FormStandScreen.navigateTo(context, id: id);
          },
          child: const Text("Créer un stand"),
        );
      }
    } else if (role == 'eleve') {
      return FloatingActionButton(
        onPressed: () {
          TombolaNewScreen.navigateTo(context, id: state.kermesse!.id);
        },
        child: const Text("Acheter tickets de tombola"),
      );
    } else if (role == 'parent') {
      return FloatingActionButton(
        onPressed: () {
          JetonNewScreen.navigateTo(context, id: state.kermesse!.id);
        },
        child: const Text("Acheter des jetons"),
      );
    }

    return null;
  }
}
