import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memories/screens/capture_trip_screen.dart';
import 'package:memories/screens/dashboard.dart';
import 'package:memories/screens/intro_screen.dart';
import 'package:memories/screens/rank_screen.dart';
import 'package:memories/screens/search_page.dart';
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
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
        routes: {
          CaptureTrip.route: (context) => CaptureTrip(),
          ViewTrip.route: (context) => ViewTrip(),
          Dashboard.route: (context) => Dashboard(),
          IntroScreen.route: (context) => IntroScreen(),
          SearchPage.route: (context) => SearchPage(),
          Rankings.route: (context) => Rankings(),
        },
        initialRoute: Dashboard.route,
      ),
    );
  }
}
