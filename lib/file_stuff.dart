import "dart:io";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";


void main() // FS
{ runApp( FileStuff () );
}

class FileStuff extends StatelessWidget
{
  FileStuff({super.key});

  @override
  Widget build( BuildContext context ) 
  { return MaterialApp
    ( title: "file stuff - Kyoungeui",
      home: FileStuffHome(),
    );
  }
}

class FileStuffHome extends StatelessWidget
{
   FileStuffHome({super.key});

  @override
  Widget build( BuildContext context ) 
  { 
    Future<String> mainDirPath = whereAmI();
    List <String> contents = readFile();

    // writeFile();
    return Scaffold
    ( appBar: AppBar( title: const Text("Grocery List - Kyoungeui") ),
      body: Text( contents.join('\n'),
      ),
    );
  }

  Future<String> whereAmI() async
  {
    Directory mainDir = await getApplicationDocumentsDirectory();
    String mainDirPath = mainDir.path;
    print("mainDirPath is $mainDirPath");
    return mainDirPath;
  }
  
  List <String> readFile()
  {
    String myStuff = "/Users/kyoungeuihong/Desktop/ITP368";
    String filePath = "$myStuff/grocery.txt";
    File groceryFile = File(filePath); // defines the file 
    if(groceryFile.existsSync()){
      List<String> contents = groceryFile.readAsLinesSync(); // opens & reads file as one big string / readAsLinesSync() getline 
      print(contents); 
      return contents; 
    }
    else{
      print("NO FILES"); 
      return []; 
    }
  }

  void writeFile()
  { String myStuff = "/Users/kyoungeuihong/Desktop/ITP368";
    String filePath = "$myStuff/writegrocery.txt";
    File groceryFile = File(filePath); // defines the file 
    groceryFile.writeAsStringSync("put this in the file");
  }
}

