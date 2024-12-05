import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/game_provider.dart';
import 'package:flutter_application_1/providers/pair_play_provider.dart';
import 'package:flutter_application_1/screens/game_screen.dart';
import 'package:flutter_application_1/screens/start_screen.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>(); 
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(); 

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=> PairPlayProvider())
    ], child: const MyApp()));}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pair Play',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, 
      ),
      home: const StartScreen(), 
    );
  }
}

