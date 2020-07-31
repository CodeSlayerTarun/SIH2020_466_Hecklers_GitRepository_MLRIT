import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memories/screens/capture_trip_screen.dart';
import 'package:memories/screens/home_screen.dart';
import 'package:memories/screens/view_trips_screen.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
      ],
      child: MaterialApp(
        routes: {
          CaptureTrip.route: (context) => CaptureTrip(),
          HomeScreen.route: (context) => HomeScreen(),
          ViewTrip.route: (context) => ViewTrip(),
        },
        initialRoute: ViewTrip.route,
      ),
    );
  }
}
