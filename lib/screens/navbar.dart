import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:memories/screens/capture_trip_screen.dart';
import 'package:memories/screens/chat_list.dart';
import 'package:memories/screens/view_trips_screen.dart';
import 'package:memories/services/auth.dart';
import 'package:memories/screens/profile.dart';
import 'package:provider/provider.dart';

class NavBarScreen extends StatefulWidget {
  static String route = 'NavbarScreen';
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    if (user == null) {
      Navigator.pop(context);
    }
    return Scaffold(
        bottomNavigationBar: BubbleBottomBar(
          opacity: 0.2,
          backgroundColor: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          currentIndex: currentIndex,
          hasInk: true,
          inkColor: Colors.green[200],
          elevation: 8.0,
          onTap: changePage,
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.public, color: Colors.black),
              activeIcon: Icon(Icons.public, color: Colors.green),
              title: Text('Trips'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.person, color: Colors.black),
              activeIcon: Icon(Icons.person, color: Colors.green),
              title: Text('Solo'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.supervisor_account, color: Colors.black),
              activeIcon: Icon(Icons.supervisor_account, color: Colors.green),
              title: Text('Clan'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.timeline, color: Colors.black),
              activeIcon: Icon(Icons.timeline, color: Colors.green),
              title: Text('Ranking'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(Icons.account_circle, color: Colors.black),
              activeIcon: Icon(Icons.account_circle, color: Colors.green),
              title: Text('Account'),
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: authService.db
                .collection('users')
                .document(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var userSnapshot = snapshot.data;
                if (userSnapshot.data != null) {
                  var userData = userSnapshot.data;
                  return (currentIndex == 0)
                      ? ProfilePage(userDetails: userData) // Trip Screen
                      : (currentIndex == 1)
                          ? ViewTrip(
                              uid: userData['uid'],
                            )
                          : (currentIndex == 2)
                              ? ChatList(
                                  userID: userData['uid'],
                                  user: userData['displayName'],
                                ) // Clan Screen
                              : (currentIndex == 3)
                                  ?
                                  CaptureTrip(userID: userData['uid'])
                                  :
                                  // ProfilePage(), // Profile Screen
                                  Icon(Icons.access_alarm);
                } else {
                  return Text('unsucessful');
                }
              } else {
                return Text('Loading');
              }
            }));
  }
}
