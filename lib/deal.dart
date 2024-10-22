import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// State class for each suitcase
class SuitcaseState {
  final int value;
  final bool isRevealed;

  SuitcaseState(this.value, this.isRevealed);

  SuitcaseState copyWith({int? value, bool? isRevealed}) {
    return SuitcaseState(
      value ?? this.value,
      isRevealed ?? this.isRevealed,
    );
  }
}

// Cubit class for managing suitcase states
class SuitcaseCubit extends Cubit<List<SuitcaseState>> {
  SuitcaseCubit() : super([]);

  // Generates the suitcases with random values
  void generateSuitcases() {
    List<int> values = [1, 5, 10, 100, 1000, 5000, 10000, 100000, 500000, 1000000];
    values.shuffle(Random());
    emit(values.map((v) => SuitcaseState(v, false)).toList());
  }

  // Reveal the suitcase
  void revealSuitcase(int index) {
    final updatedSuitcases = List<SuitcaseState>.from(state);
    if (index != updatedSuitcases.length - 1) {
      updatedSuitcases[index] = updatedSuitcases[index].copyWith(isRevealed: true);
    }
    emit(updatedSuitcases);
  }

  // Calculate Dealer's Offer
  String calculateOffer() {
    int total = 0;
    int unrevealedSuits = 0;
    for (var suitcase in state) {
      if (!suitcase.isRevealed) {
        total += suitcase.value;
        unrevealedSuits++;
      }
    }
    if (unrevealedSuits == 1) {
      return "\$${state.last.value.toStringAsFixed(2)}";
    } else if (unrevealedSuits == state.length) {
      return "Please Pick A Suitcase";
    } else {
      return "\$${((total / unrevealedSuits) * 0.9).toStringAsFixed(2)}";
    }
  }
}

// Suitcase widget
class Suitcase extends StatelessWidget {
  final int index;
  const Suitcase({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuitcaseCubit, List<SuitcaseState>>(
      builder: (context, suitcases) {
        if (suitcases.isEmpty || index >= suitcases.length) {
          return const SizedBox();
        }
        final suitcase = suitcases[index];
        return FloatingActionButton(
          onPressed: () {
            if (!suitcase.isRevealed) {
              context.read<SuitcaseCubit>().revealSuitcase(index);
            }
          },
          backgroundColor: suitcase.isRevealed ? Colors.yellow : Colors.black,
          child: Center(
            child: Text(
              suitcase.isRevealed ? "\$${suitcase.value}" : "?",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(Deal());
}

class Deal extends StatelessWidget {
  const Deal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SuitcaseCubit()..generateSuitcases(),
      child: MaterialApp(
        title: "Deal or No Deal",
        home: DealHome(),
      ),
    );
  }
}

class DealHome extends StatelessWidget {
  final TextEditingController tec = TextEditingController();

  DealHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sc = BlocProvider.of<SuitcaseCubit>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Deal or No Deal")),
      body: BlocBuilder<SuitcaseCubit, List<SuitcaseState>>(
        builder: (context, suitcases) {
          if (suitcases.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Dealer's Offer",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 20),
              Container(
                width: 140,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    sc.calculateOffer(),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Suitcase(index: 0),
                  SizedBox(width: 20),
                  Suitcase(index: 1),
                  SizedBox(width: 20),
                  Suitcase(index: 2),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Suitcase(index: 3),
                  SizedBox(width: 20),
                  Suitcase(index: 4),
                  SizedBox(width: 20),
                  Suitcase(index: 5),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Suitcase(index: 6),
                  SizedBox(width: 20),
                  Suitcase(index: 7),
                  SizedBox(width: 20),
                  Suitcase(index: 8),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black),
                    ),
                    child: const Center(child: Text("User Suitcase")),
                  ),
                  const SizedBox(width: 10),
                  // User's suitcase
                  Suitcase(index: 9),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: tec,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Enter 'd' for Deal or 'nd' for No Deal",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  String input = tec.text.trim().toLowerCase();
                  if (input == "d") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("You Accepted The Deal!")),
                    );
                  } else if (input == "nd") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: sc,
                          child: ShowResult(),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid Command! Use 'd' or 'nd'.")),
                    );
                  }
                },
                child: const Text("Enter"),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ShowResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Show Result")),
      body: BlocBuilder<SuitcaseCubit, List<SuitcaseState>>(
        builder: (context, suitcases) {
          if (suitcases.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          // Sort the list by values
          List<SuitcaseState> sortedSuitcases = List.from(suitcases);
          sortedSuitcases.sort((a, b) => a.value.compareTo(b.value));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First Row: Values 1-5 (smallest values)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < 5; i++)
                      Container(
                        width: 50,
                        height: 50,
                        color: sortedSuitcases[i].isRevealed ? Colors.grey : Colors.amber,
                        alignment: Alignment.center,
                        child: Text(
                          "\$${sortedSuitcases[i].value}",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20), // Spacing between rows
                // Second Row: Values 6-10 (next five values)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 5; i < 10; i++)
                      Container(
                        width: 50,
                        height: 50,
                        color: sortedSuitcases[i].isRevealed ? Colors.grey : Colors.amber,
                        alignment: Alignment.center,
                        child: Text(
                          "\$${sortedSuitcases[i].value}",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.arrow_back),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
