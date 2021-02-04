import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF276678),
        textTheme: GoogleFonts.dmSansTextTheme()
            .apply(displayColor: Color(0xFF171717)),
        scaffoldBackgroundColor: Color(0xFFfff3e6),
      ),
      home: HomePage(),
    );
  }
}
