import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

// Initialize the Lights 
class LightState{
  bool isOn;
  LightState(this.isOn); 
}

class LightCubit extends Cubit<LightState>{ 
  LightCubit() : super(LightState(true)); 
}

class PanelState{ 
  List<LightState> panel = [];
  Random random = Random(); 
  
  PanelState(int n){
    for (int i=0; i<n; i++){
      bool isOn = random.nextBool(); 
      panel.add(LightState(isOn)); 
    }
  }
}

class PanelCubit extends Cubit<PanelState>{
  PanelCubit(int n) : super(PanelState(n));

  void toggle(int index){
    final currentPanel = state.panel; 

    currentPanel[index].isOn = !currentPanel[index].isOn; 

    // if left exits 
    if (index>0){
      currentPanel[index-1].isOn = !currentPanel[index-1].isOn; 
    }

    // if right exists
    if (index<currentPanel.length-1){
      currentPanel[index+1].isOn = !currentPanel[index+1].isOn; 
    }

    emit(PanelState(currentPanel.length)..panel = currentPanel);
  }

  void update(int n){emit (PanelState(n));}
}

void main(){
  runApp(LightsOut()); 
}

class LightsOut extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>PanelCubit(5), //initialized with 5 lights 
      child: MaterialApp(
        title: "Lights Out", 
        home: LightsOutPage(), 
      ),);
  }
}

class LightsOutPage extends StatelessWidget{
  final TextEditingController tec = TextEditingController(); 

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:Text("Lights Out")),
      body: BlocBuilder<PanelCubit, PanelState>(
        builder:(context,state){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(state.panel.length, (index){
                return GestureDetector(
                  onTap:(){
                    context.read<PanelCubit>().toggle(index); 
                  }, 
                  child: Container(
                    width: 60, 
                    height: 60, 
                    decoration: BoxDecoration(
                      color: state.panel[index].isOn? Colors.yellow: Colors.grey, 
                      border: Border.all(width:2,), 
                    ),
                    child: Center(
                      child: Center(
                        child: 
                        Text((index+1).toString(), 
                        style: TextStyle(color:Colors.black), 
                        ),) ))
                ); 
              }),
             ),
              SizedBox(height: 20),
              TextField(
                controller: tec,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter number of lights",
                  border: OutlineInputBorder(),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  int n = int.parse(tec.text); 
                  context.read<PanelCubit>().update(n);
                },
                child: Icon(Icons.refresh), // Use an icon for the button
              ),
            ],
          ); 
        },
      ),
    );
  }
}

  