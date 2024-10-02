import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ScoreUmpire.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Umpire App',
      home: ScoreUmpireApp(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xffc5b171),
          brightness: Brightness.light,
        ),

       
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.acme(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          bodyMedium: GoogleFonts.merriweather(fontSize: 18),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


