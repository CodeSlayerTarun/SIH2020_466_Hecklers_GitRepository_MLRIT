import 'package:flutter/material.dart';
import 'package:memories/screens/home_screen.dart';

void main() {
  runApp(Memories());
}

class Memories extends StatefulWidget {
  @override
  _MemoriesState createState() => _MemoriesState();
}

class _MemoriesState extends State<Memories> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
