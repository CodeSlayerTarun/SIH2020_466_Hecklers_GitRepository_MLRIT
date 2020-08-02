import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                ? StreamBuilder<DocumentSnapshot>(
                    stream: authService.db
                        .collection('users')
                        .document(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var userSnapshot = snapshot.data;
                        print(userSnapshot.data);
                        if (userSnapshot.data != null) {
                          return UserDetails(
                            userDetails: userSnapshot.data,
                          );
                        } else {
                          authService.signOut();
                          return RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                                'User not loggedin successfully, Try Again'),
                          );
                        }
                      } else {
                        return Text('Loading');
                      }
                    })
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
  final Map<String, dynamic> userDetails;
  UserDetails({this.userDetails});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(userDetails['displayName']),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewTrip(
                            uid: userDetails['uid'],
                          )));
            },
            child: Text('ViewTrip'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, CaptureTrip.route,
                  arguments: {'uid': userDetails['uid']});
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
