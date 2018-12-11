import 'package:flutter/material.dart';
import 'package:twenty_forty_seven/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      home: Home(),
    );
  }
}
