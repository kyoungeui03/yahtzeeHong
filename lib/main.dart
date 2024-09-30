import 'package:flutter/material.dart';
import 'package:flutter_application_1/pancake.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncrementState {
  int count;
  IncrementState(this.count);
}

// Cubit
class IncrementCubit extends Cubit<IncrementState> {
  IncrementCubit() : super(IncrementState(0));

  void update() {
    emit(IncrementState(state.count + 1));
  }
}

void main() {
  runApp(PancakeApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncrementCubit(),
      child: MaterialApp(
        title: "Bloc Demo",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Bloc Demo"),
      ),
      body: BlocBuilder<IncrementCubit, IncrementState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '${state.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call the Cubit method to increment the counter
          IncrementCubit ic = BlocProvider.of<IncrementCubit>(context); 
          ic.update(); 
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
