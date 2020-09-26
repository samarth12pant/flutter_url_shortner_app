import 'package:flutter/material.dart';
import 'package:url_shortner/shortner_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"URL-Shortner",
      debugShowCheckedModeBanner: false,
      home:MainPage(),
    );
  }
}