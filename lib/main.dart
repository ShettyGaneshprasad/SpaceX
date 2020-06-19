import 'package:flutter/material.dart';
import 'package:spacex/SpaceX.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      title: 'Space X',
      theme: ThemeData(
        backgroundColor: Colors.black,
        primarySwatch: Colors.blue,
        fontFamily: "Arial",
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
      home: SpaceX(),
    );
  }
}
