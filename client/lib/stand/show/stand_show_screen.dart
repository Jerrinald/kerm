import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/core/models/stand.dart';
import 'package:flutter_flash_event/kermesse/show/kermesse_show_screen.dart';
import 'package:flutter_flash_event/stand/access/stand_access_screen.dart';
import 'package:flutter_flash_event/stand/form/form_stand_screen.dart';
import 'package:flutter_flash_event/stand/show/bloc/stand_show_bloc.dart';
import 'package:flutter_flash_event/stand/stock/stock_screen.dart';
import 'package:intl/intl.dart';

class StandShowScreen extends StatelessWidget {
  static const String routeName = '/stand-show';

  static navigateTo(BuildContext context, {required int id}) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  final int id;

  const StandShowScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StandShowBloc()..add(StandDataLoaded(id: id)),
      child: BlocBuilder<StandShowBloc, StandShowState>(
        builder: (context, state) {
          final stand = state.stand;
          final role = state.role;

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Stand Details'),
              ),
              body: state.status == StandShowStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : stand != null
                  ? Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stand Type: ${stand.type}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Achat de ${stand.name}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      if (state.role == 'standOwner' || state.role == 'organisateur') ...[
                        Text(
                          'Stock restants: ${state.stand!.stock}', // Display remaining stock
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to stock management screen
                            StockScreen.navigateTo(context, id: state.stand!.id);
                          },
                          child: const Text('Gérer le stock'),
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Add more widgets displaying other stand details as needed
                    ],
                  ),
                ),
              )
                  : const Center(child: Text("Stand not found")),
              floatingActionButton: _buildFloatingActionButton(context, stand, role),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align the button to the start (left)
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        KermesseShowScreen.navigateTo(context, id: state.stand!.kermesseId);
                      },
                      child: const Text('Back'),
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

  // Method to determine button text based on stand type and user role
  Widget? _buildFloatingActionButton(BuildContext context, Stand? stand, String? role) {
    // Return null if stand or role is not set
    if (stand == null || role == null || (role != 'eleve' && role != 'parent') ) {
      return null;
    }

    // Determine the button text based on the stand type
    String buttonText;
    switch (stand.type.toLowerCase()) {
      case 'food':
        buttonText = 'Acheter nourriture';
        break;
      case 'drink':
        buttonText = 'Acheter une boisson';
        break;
      case 'activity':
        buttonText = 'Participer';
        break;
      default:
        buttonText = 'Participer';  // Default action
        break;
    }

    // Build the button with the appropriate action
    return FloatingActionButton(
      onPressed: () {
        _handleButtonAction(context, stand.type);
      },
      child: Text(buttonText),
    );
  }

  // Method to handle different actions based on stand type
  void _handleButtonAction(BuildContext context, String? standType) {
    if (standType != null) {
      switch (standType.toLowerCase()) {
        case 'food':
        // Handle food purchase logic
          StandAccessScreen.navigateTo(context, id: id);
          break;
        case 'drink':
        // Handle drink purchase logic
          StandAccessScreen.navigateTo(context, id: id);
          break;
        case 'activity':
        // Handle participation logic
          StandAccessScreen.navigateTo(context, id: id);
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Action non disponible!')),
          );
          break;
      }
    }
  }
}