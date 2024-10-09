import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/stand/show/stand_show_screen.dart';
import 'package:flutter_flash_event/stand/stock/bloc/stock_bloc.dart';
import 'package:intl/intl.dart';

class StockScreen extends StatelessWidget {
  static const String routeName = '/stand-stock';

  // Navigation method that provides the StockBloc and triggers the StockLoaded event
  static navigateTo(BuildContext context, {required int id}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider<StockBloc>(
          create: (context) {
            final bloc = StockBloc();  // Create the bloc
            bloc.add(StockLoaded(id: id)); // Trigger StockLoaded when the screen loads
            return bloc;
          },
          child: StockScreen(id: id),
        ),
      ),
    );
  }

  final int id;

  const StockScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stockBloc = BlocProvider.of<StockBloc>(context);
    int counter = 0; // Initialize counter to 0 initially, but it will be set from state

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stand Stock'),
      ),
      body: BlocBuilder<StockBloc, StockState>(
        builder: (context, state) {
          // Loading state
          if (state.status == StockStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final stand = state.stand;
          if (stand == null) {
            return const Center(child: Text("Stand not found"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stand: ${stand.name}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Counter display
                const Text('Quantité:', style: TextStyle(fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (counter > 0) {
                          counter--;
                          stockBloc.add(ValidateFormEvent(stock: counter.toString()));
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
                        stockBloc.add(ValidateFormEvent(stock: counter.toString()));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Conditionally show the submit button if counter > initial stock
                if (counter > stand.stock)
                  ElevatedButton(
                    onPressed: () {
                      stockBloc.add(SubmitEvent(
                          id: stand.id,
                          stock: counter.toString(),
                          onSuccess: () {
                            StandShowScreen.navigateTo(context, id: state.stand!.id);
                          },
                          onError: (errorMessage) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          },
                      ));
                    },
                    child: Text('Valider Stock ($counter)'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}