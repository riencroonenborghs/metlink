import "package:flutter/material.dart";
import "package:metlink/pages/pages.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Metlink",
      theme: ThemeData(
        primaryColor: Color.fromRGBO(0, 109, 178, 1),
        accentColor: Color.fromRGBO(196, 219, 12, 1)
      ),
      home: MapPage()
    );
  }
}