// Barrett Koster 2024
// Ligihts Out ... with BLoC

import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PanelState
{
  List<Light> panel = [];

  PanelState( int n ) 
  { panel = [];
    for ( int i=0; i<n; i++ )
    { panel.add(Light()); }
    for ( int i=1; i<n-1; i++ )
    { panel[i].addNeighbor(panel[i-1]);
      panel[i].addNeighbor(panel[i+1]);
    }
    panel[0].addNeighbor(panel[1]);
    panel[n-1].addNeighbor(panel[n-2]);
  }
}
class PanelCubit extends Cubit<PanelState>
{
  PanelCubit(int n) : super( PanelState(n) );

  void update( int n ) { emit( PanelState(n) ); }
}

void main() // 123
{ runApp( LightsOut() );
}

class LightsOut extends StatelessWidget
{ LightsOut({super.key});
  @override
  Widget build( BuildContext context )
  { return  MaterialApp
    ( title: "LightsOut - Barrett",
      home: LightsOutHome(),
    );
  }
}

class LightsOutHome extends StatelessWidget
{
  @override
  Widget build( BuildContext context )
  { return Scaffold
    ( appBar: AppBar(title: Text("Lights Out - Barrett") ),
      body: LOBody(),
    );
  }
}

class LOBody extends StatelessWidget
{ 
  Widget build( BuildContext context )
  { TextEditingController tec = TextEditingController();
    tec.text="9";
    return BlocProvider<PanelCubit>
    ( create: (context) => PanelCubit(9),
      child: BlocBuilder<PanelCubit,PanelState>
      ( builder: (context, panelState)
        { return Column
          ( children: 
            [ Row( children: 
                BlocProvider.of<PanelCubit>(context).state.panel, 
              ),
              TextField( controller: tec),
              FloatingActionButton
              ( onPressed: ()
                { int n = int.parse(tec.text);
                  BlocProvider.of<PanelCubit>(context).update(n);
                },
                child: Text("new number of lights"),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LightState
{
  late bool isOn;

  LightState( this.isOn );
  LightState.random()
  { Random randy = Random(); 
    isOn = randy.nextBool(); 
  } 
}
class LightCubit extends Cubit<LightState>
{
  LightCubit( ) : super( LightState.random() );

  void update( bool zon ) { emit( LightState(zon) ); }
  void toggle() { emit( LightState(!state.isOn) ); }
}

class Light extends StatelessWidget
{
  final List<Light> neighbors = []; // ones on each side (or one side)

  void addNeighbor( Light li ) { neighbors.add(li); }

  late BuildContext bc;
  
  @override
  Widget build( BuildContext context )
  { return BlocProvider<LightCubit>
    ( create: (context) => (LightCubit()),
      child: BlocBuilder<LightCubit,LightState>
      ( builder: (context, lightState)
        { return Builder
          ( builder: (context)
            { LightCubit lc = BlocProvider.of<LightCubit>(context);
              bc = context;
              return Column
                ( children:
                  [  Container
                    ( height: 60, width: 60,
                      decoration: BoxDecoration
                      ( border: Border.all(width:2),
                        color: lc.state.isOn
                          ? Colors.yellow: Colors.brown,
                      ),
                    ),
                    FloatingActionButton
                    ( onPressed: ()
                      { lc.update( !BlocProvider.of<LightCubit>(context).state.isOn );
                        for ( Light li in neighbors )
                        {
                          li.toggle();
                        }
                      },
                    ),
                  ],
                );
            },
          );
         
        },
      ),
    );
  }

  void toggle()
  {
    LightCubit lc = BlocProvider.of<LightCubit>(bc);
    lc.toggle();
  }
}