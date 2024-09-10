// Barrett Koster 2024

import "package:flutter/material.dart";

void main()
{ runApp(Robot());
}

// demo of a simple page
class Robot extends StatelessWidget // need to use flutter
{
  Robot({super.key}); // essential

  @override
  Widget build(BuildContext context) //writing inside the flutter
  { return MaterialApp // default 
    ( title: "Week2 Assignment",
      home: RobotHome(),
    );
  }
}

class RobotHome extends StatefulWidget
{
  @override
  State<RobotHome> createState() => RobotHomeState();
}


//Main Backend & Logic goes inside State class 
class RobotHomeState extends State<RobotHome>
{  
  int lim = 5; 
  int row = 2; 
  int col = 2; 

  // build makes the PigHomeState widget
  @override
  //nxm grid & learn how to use children syntax
  Widget build( BuildContext context )
  { 
    // grid is build by loop here, included in widget
    // tree later.
    Column grid = Column(children:[]);
    for (int r=0; r<lim; r++)
    { Row arow = Row(children:[]);
      for(int c=0; c<lim; c++ )
      {
        if ((r==row && c==col)){
          arow.children.add(TextWithBorder("R")); 
        }
        else{arow.children.add( TextWithBorder("") );}
      }
      grid.children.add(arow);
    }

    // Scaffold is the screen contents for PigHomeState
    return Scaffold //essential to call Scaffold Widget
    ( appBar: AppBar(title:Text("Robot")),
      body: Row
      (
        children:
        [ grid, 
          FloatingActionButton
          ( onPressed: ()
            { setState
              ( ()
                { if(row > 0){
                  row --; 
                }
                }
              );
            },
            child: Text("up"), // name of the button
          ),
          FloatingActionButton
          ( onPressed: ()
            { setState
              ( ()
                { if(row < lim-1){
                  row ++; 
                }
                }
              );
            },
            child: Text("down"), // name of the button
          ),
          FloatingActionButton
          ( onPressed: ()
            { setState
              ( ()
                { if(col >0){
                  col --; 
                }
                }
              );
            },
            child: Text("left"), // name of the button
          ),
          FloatingActionButton
          ( onPressed: ()
            { setState
              ( ()
                { if(col < lim-1){
                  col ++; 
                }
                }
              );
            },
            child: Text("right"), // name of the button
          ),
        ],
    ),
  );
  }
}

// box with some text in it.
class TextWithBorder extends StatelessWidget
{
  final String s; // this is what is in the box

  const TextWithBorder(this.s, {super.key});

  @override
  Widget build( BuildContext context )
  {
    return Container
    ( height: 50,
      width: 50,
      decoration: BoxDecoration
      ( border: Border.all
                (width:2,color: const Color(0xff0000ff)),
      ),
          
      child: Text(s),
    );
  }
}
