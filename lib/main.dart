import 'package:flutter/material.dart';
import 'package:piton_todo/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Anasayfayı çağırır
      home: HomePage(),
    );
  }
}
