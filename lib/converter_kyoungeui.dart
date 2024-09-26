import "package:flutter/material.dart";

void main() 
{
  runApp(Converter());
}

class Converter extends StatelessWidget
{
  Converter({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "Converter - Kyoungeui",
      home: ConverterHome(),
    );
  }
}

class ConverterHome extends StatefulWidget
{
  @override
  State<ConverterHome> createState() => ConverterHomeState();
}

class ConverterHomeState extends State<ConverterHome>
{
  String inputNumber = "" ;
  String outputNumber = ""; 

  Calculation c = Calculation(); 

  //Shows the number that User Pressed
  // If the User Press ResetButton, then its ready for the next calculation 
  void pressedNumber(String userInput){
    setState(() {
      if (userInput == "Reset"){
        inputNumber = ""; 
        outputNumber = ""; 
      }
      else{
      inputNumber += userInput;} 
    });
  }

  @override
  Widget build( BuildContext context )
  { 
    return Scaffold
    ( appBar: AppBar(title: const Text("Converter")),
      body: Column(
        children: [
        const Center(
          child: Text("Left is original & Right is converted"),
        ),
        // Inout & Output Number Screen
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextWithBorder(inputNumber), 
            const Text("-------------------------------------->"), 
            TextWithBorder(outputNumber), 
          ],
        ),
        const SizedBox(height: 30), 
        // Row1 4 Conversion Buttons 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // C to F Button 
            FloatingActionButton(
              onPressed:(){setState(() {
                outputNumber= c.ctof(inputNumber); 
              });}, 
              child: Text("C to F"),),
            // F to C Button 
               FloatingActionButton(
              onPressed:(){setState(() {
                outputNumber= c.ftoc(inputNumber); 
              });}, 
              child: Text("F to C"),),
            // P to K Button 
               FloatingActionButton(
              onPressed:(){setState(() {
                outputNumber= c.ptok(inputNumber); 
              });}, 
              child: Text("P to Kg"),),
            // K to P Button 
               FloatingActionButton(
              onPressed:(){setState(() {
                outputNumber= c.ktop(inputNumber); 
              });}, 
              child: Text("Kg to P"),),
        ],),
        // Row2 9 Number Buttons 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(label: "1", onPressed: pressedNumber),
            NumberButton(label: "2", onPressed: pressedNumber),
            NumberButton(label: "3", onPressed: pressedNumber),
            NumberButton(label: "4", onPressed: pressedNumber), 
        ],),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(label: "5", onPressed: pressedNumber),
            NumberButton(label: "6", onPressed: pressedNumber),
            NumberButton(label: "7", onPressed: pressedNumber),
            NumberButton(label: "8", onPressed: pressedNumber), 
        ],),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(label: "9", onPressed: pressedNumber),
            NumberButton(label: "0", onPressed: pressedNumber),
            NumberButton(label: ".", onPressed: pressedNumber),
            NumberButton(label: "Reset", onPressed: pressedNumber), 
        ],),
      ],),  
      ); 
      }
}

//Borders for Input & Ouput 
class TextWithBorder extends StatelessWidget
{
  final String s; // this is what is in the box

  const TextWithBorder(this.s, {super.key});

  @override
  Widget build( BuildContext context )
  {
    return Container
    ( height: 40,
      width: 70,
      decoration: BoxDecoration
      ( border: Border.all
                (width:2,color: const Color.fromARGB(255, 0, 255, 51)),
      ),
      child: Text(s),
    );
  }
}

//Calculates the Conversion 
class Calculation{

  // Fahrenheit to Celsius
  String ftoc(String number) {
    double fahrenheit = double.parse(number);
    double celsius = (fahrenheit - 32) * 5 / 9;
    return celsius.toStringAsFixed(2); // Limit to 2 decimal places
  }

  // Celsius to Fahrenheit
  String ctof(String number) {
    double celsius = double.parse(number);
    double fahrenheit = (celsius * 9 / 5) + 32;
    return fahrenheit.toStringAsFixed(2); // Limit to 2 decimal places
  }

  // Pound to Kilogram
  String ptok(String number) {
    double pounds = double.parse(number);
    double kilograms = pounds * 0.453592;
    return kilograms.toStringAsFixed(2); // Limit to 2 decimal places
  }

  // Kilogram to Pound
  String ktop(String number) {
    double kilograms = double.parse(number);
    double pounds = kilograms / 0.453592;
    return pounds.toStringAsFixed(2); // Limit to 2 decimal places
  }
}

//Creates Number Buttons and builds constructors to create buttons 
class NumberButton extends StatelessWidget
{
  final String label; 
  final Function(String) onPressed; 

  //Looked up Flutter Syntax to use this code 
  const NumberButton({required this.label, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return FloatingActionButton(
      onPressed: () => onPressed(label),
      child: Text(label)
    ); 
  }
}