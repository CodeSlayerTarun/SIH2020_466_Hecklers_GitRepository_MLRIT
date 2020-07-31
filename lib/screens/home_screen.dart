import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memories/models/user_model.dart';
import 'package:memories/screens/capture_trip_screen.dart';
import 'package:memories/screens/view_trips_screen.dart';
import 'package:memories/services/auth.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String route = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: (loggedIn)
                ? StreamProvider<User>.value(
                    value: authService.streamUser(uid: user.uid),
                    initialData: User(displayName: '', photoURL: '', uid: ''),
                    child: UserDetails(),
                  )
                : RaisedButton(
                    onPressed: () {
                      authService.googleSignIn();
                    },
                    child: Text('SignIn'),
                  )),
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<User>(context);
    print(userDetails.displayName);
    print(userDetails.uid);
    return Container(
      child: Column(
        children: <Widget>[
          Text(userDetails.displayName),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, ViewTrip.route,
                  arguments: {'uid': userDetails.uid});
            },
            child: Text('ViewTrip'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, CaptureTrip.route,
                  arguments: {'uid': userDetails.uid});
            },
            child: Text('CaptureTrip'),
          ),
          RaisedButton(
            onPressed: () {
              authService.signOut();
            },
            child: Text('Signout'),
          )
        ],
      ),
    );
  }
}
