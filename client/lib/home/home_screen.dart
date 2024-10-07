import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/demande/all/demande_all_screen.dart';
import 'package:flutter_flash_event/home/blocs/home_bloc.dart';
import 'package:flutter_flash_event/kermesse/form/form_kermesse_screen.dart';
import 'package:flutter_flash_event/kermesse/show/kermesse_show_screen.dart';
import 'package:flutter_flash_event/myAccount/my_account_screen.dart';
import 'package:flutter_flash_event/stand/form/form_stand_screen.dart';

class HomeScreen extends StatelessWidget {

  static const String routeName = '/';

  static navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeDataLoaded()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is HomeDataLoadError) {
                return Center(
                  child: Text(state.errorMessage),
                );
              }

              if (state is HomeDataLoadSuccess) {
                final int myKermessesCount = state.myKermesses.length;
                final int allKermessesCount = state.allKermesses.length;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              // Action pour le menu
                            },
                          ),
                          Image.asset(
                            'assets/flash-event-logo.png',
                            height: 60, // Ajuster la taille du logo selon vos besoins
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.shade300,
                            child: IconButton(
                              icon: const Icon(Icons.person),
                              onPressed: () => MyAccountScreen.navigateTo(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          DemandeAllScreen.navigateTo(context);
                        },
                        // Dynamically display the button text based on counter
                        child: Text('Liste des demandes'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Kermesses',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (myKermessesCount == 0)
                        const Center(
                          child: Text(
                            'Aucune kermesse à afficher pour le moment',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: myKermessesCount,
                            itemBuilder: (context, index) {
                              final kermesse = state.myKermesses[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  title: Text(kermesse.name),
                                  onTap: () {
                                    KermesseShowScreen.navigateTo(context, id: kermesse.id);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 8),
                      const Text(
                        'Toutes les kermesses',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (allKermessesCount == 0)
                        const Center(
                          child: Text(
                            'Aucune kermesse à afficher pour le moment',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: allKermessesCount,
                            itemBuilder: (context, index) {
                              final kermesse = state.allKermesses[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  title: Text(kermesse.name),
                                  onTap: () {
                                    KermesseShowScreen.navigateTo(context, id: kermesse.id);
                                  },
                                ),
                              );
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the add event screen
            FormKermesseScreen.navigateTo(context);
          },
          child: Icon(Icons.add),
          backgroundColor: const Color(0xFF6058E9),
        ),

      ),
    );
  }
}