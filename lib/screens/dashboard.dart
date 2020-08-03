import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memories/screens/capture_trip_screen.dart';
import 'package:memories/screens/chat_list.dart';
import 'package:memories/screens/intro_screen.dart';
// import 'package:memories/screens/intro_slider.dart';
import 'package:memories/screens/profile.dart';
import 'package:memories/screens/rank_screen.dart';
import 'package:memories/screens/search_page.dart';
import 'package:memories/screens/view_trips_screen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static String route = 'Dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Firestore _db = Firestore.instance;
  int pageIndex = 0;
  List<Widget> pageList = [];

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    return (loggedIn)
        ? Scaffold(
            body: StreamBuilder<DocumentSnapshot>(
                stream: _db.collection('users').document(user.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var userSnapshot = snapshot.data;
                    if (userSnapshot.data != null) {
                      var userDetails = userSnapshot.data;
                      pageList = [
                        Profile(),
                        Rankings(),
                        ChatList(
                          userID: userDetails['uid'],
                          user: userDetails['displayName'],
                        ),
                        ViewTrip(
                          uid: userDetails['uid'],
                        ),
                        CaptureTrip(),
                        SearchPage(),
                      ];
                      return pageList[pageIndex];
                    } else {
                      return Text('No User');
                    }
                  } else {
                    return Text('No User');
                  }
                }),
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                  // sets the background color of the `BottomNavigationBar`
                  canvasColor: Colors.black,
                  // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                  primaryColor: Colors.red,
                  textTheme: Theme.of(context)
                      .textTheme
                      .copyWith(caption: new TextStyle(color: Colors.yellow))),
              child: BottomNavigationBar(
                currentIndex: pageIndex,
                onTap: (int index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
                backgroundColor: Colors.black54,
                items: [
                  BottomNavigationBarItem(
                      icon: FaIcon(
                        FontAwesomeIcons.userAlt,
                        size: 22.0,
                      ),
                      title: Text('Profile')),
                  BottomNavigationBarItem(
                      icon: FaIcon(
                        FontAwesomeIcons.award,
                        size: 26.0,
                      ),
                      title: Text('Clans')),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.users),
                      title: Text('Clans')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.map), title: Text('View Trips')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.navigation),
                      title: Text('Capture Trip')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.beach_access),
                      title: Text('Itineraries')),
                ],
              ),
            ),
          )
        : IntroScreen();
  }
}
