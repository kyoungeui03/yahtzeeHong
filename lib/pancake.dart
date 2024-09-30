import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

// Define PancakeState 

class PancakeState{
  final List<int> pancakes; 
  final int flips; 
  PancakeState(this.pancakes, this.flips); //constructor 
}

//Define Cubit 

class PancakeCubit extends Cubit<PancakeState>{
  // super --> Initialize PancakeState
  PancakeCubit() : super(PancakeState([], 0)){
    generateStack(2); //Starting with 2 pancakes 
  } 

  //Generates a pancake stack 
  void generateStack(int cnt){
    List<int> stack = List.generate(cnt, (i)=>i+1); 
    stack.shuffle(Random()); 
    emit(PancakeState(stack, 0)); 
  }

  // flips the pancake stack & grabs the index and flip all upper pancakes 
  void flip(int index){
    final currentState = state; 
    if (index >=0  && index<currentState.pancakes.length){
      List<int> changedStack = List.from(currentState.pancakes); 
      for (int i=0; i<(index+1)/2; i++){
        final temp = changedStack[i]; 
        changedStack[i] = changedStack[index-i]; 
        changedStack[index-i] = temp; 
      }
      emit(PancakeState(changedStack, currentState.flips+1)); 
    }
  }

  //resets the game 
  void reset(){
    generateStack(state.pancakes.length); 
  }

  // changes the number of pancakes (2,20)
  void changeStackSize(int number){
    int changedSize = (state.pancakes.length + number);
    if ((changedSize >= 2) && (changedSize) <=20){
      generateStack(changedSize); 
    }
  }
}

void main(){
  runApp (PancakeApp()); 
}

class PancakeApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>PancakeCubit(),
      child: MaterialApp(
        title: "Pancake Game", 
        home: PancakePage(), 
      ),);
  }
}

class PancakePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pancake Game"),),
      body: BlocBuilder<PancakeCubit, PancakeState>(
        builder:(context, pancakeState){
          List<Widget> pancakeWidgets = []; 
          for (int i=0; i<pancakeState.pancakes.length; i++){
                pancakeWidgets.add(
                  //enables user interaction 
                  TextButton(onPressed: (){
                    context.read<PancakeCubit>().flip(i); 
                  }, 
                  child: makePancake(pancakeState.pancakes[i]),));
              }
      
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${pancakeState.flips} Flips!", style: const TextStyle(fontSize: 25),), 
              const SizedBox(height: 20),
              ...pancakeWidgets, //insert the pancakeWidgets 
              const SizedBox(height:20), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // Reset Button 
                FloatingActionButton(
                  onPressed: (){
                    context.read<PancakeCubit>().reset(); 
                  }, 
                  child: const Text("Reset"),),
                SizedBox(width:10), 
                // Add Pancake  
                FloatingActionButton(onPressed: (){
                  context.read<PancakeCubit>().changeStackSize(1); 
                },
                child: const Text("+"),),
                SizedBox(width:10),  
                // Remove Pancake 
                FloatingActionButton(onPressed: (){
                  context.read<PancakeCubit>().changeStackSize(-1); 
                },
                child: const Text("-"),), 
              ],)

            ],
          );
        },)
    );
  }
}

Widget makePancake(int pancakeLevel){
    return Container(
      width: pancakeLevel*20, 
      height: 30, 
      color: Colors.brown,
      child: Center(
        child: Text(pancakeLevel.toString(),
        style: const TextStyle(color:Colors.white)),)
    );
  }
