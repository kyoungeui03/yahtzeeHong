// Barrett Koster 2024
// demo of a simple page (pig latin translator).
// THe 'plus' version has a couple of grids (unrelated to
// piglatin) to show how to do that.

import "package:flutter/material.dart";

void main()
{ runApp(PigLatin());
}

// demo of a simple page
class PigLatin extends StatelessWidget // need to use flutter
{
  PigLatin({super.key}); // essential

  @override
  Widget build(BuildContext context) //writing inside the flutter
  { return MaterialApp // default 
    ( title: "whatEVER",
      home: PigHome(),
    );
  }
}

class PigHome extends StatefulWidget
{
  @override
  State<PigHome> createState() => PigHomeState();
}


//Main Backend & Logic goes inside State class 
class PigHomeState extends State<PigHome>
{ String saying = "stuff"; // piglatin will get put here.
  TextEditingController tec = TextEditingController();

  // build makes the PigHomeState widget
  @override
  //nxm grid & learn how to use children syntax
  Widget build( BuildContext context )
  { 
    // grid2 is build by loop here, included in widget
    // tree later.
    Column grid2 = Column(children:[]);
    for ( int y = 0; y<5; y++ )
    { Row arow = Row(children:[]);
      for( int x=0; x<5; x++ )
      {
        arow.children.add( TextWithBorder("$x $y") );
      }
      grid2.children.add(arow);
    }

    // Scaffold is the screen contents for PigHomeState
    return Scaffold //essential to call Scaffold Widget
    ( appBar: AppBar(title:Text("Pig Latin")),
      body: Column
      ( children:
        [ Text(saying),
          TextField
          ( controller: tec ),
          FloatingActionButton
          ( onPressed: ()
            { setState
              ( ()
                { String s = tec.text; // get contents of text box
                  String h = s[0];
                  s = "${s.substring(1)}${h}ay"; // pig latin
                  saying = s;
                }
              );
            },
            child: Text("do it"), // name of the button
          ),
          // Now just some unrelated useful things
          const Column
          ( children:
            [ Row 
              ( children:
                [ TextWithBorder("how"),
                  TextWithBorder("now"),
                ],
              ),
              Row
              ( children:
                [ TextWithBorder("brown"),
                  TextWithBorder("cow"),
                ],

              ),
            ], 
          ),
          const Text("and now here is grid2:"),
          grid2,
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
