import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memories/screens/capture_trip_screen.dart';
import 'package:memories/screens/chat_list.dart';
import 'package:memories/screens/view_trips_screen.dart';
import 'package:memories/services/auth.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:memories/models/slider_model.dart';

class HomeScreen extends StatefulWidget {
  static String route = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SliderModel> mySLides = new List<SliderModel>();
  int slideIndex = 0;
  PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                    },
                  )
                : Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      const Color(0xff3C8CE7),
                      const Color(0xff00EAFF)
                    ])),
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Container(
                        height: MediaQuery.of(context).size.height - 100,
                        child: PageView(
                          controller: controller,
                          onPageChanged: (index) {
                            setState(() {
                              slideIndex = index;
                            });
                          },
                          children: <Widget>[
                            Slidetil(
                              imagePath: mySLides[0].getImageAssetPath(),
                              title: mySLides[0].getTitle(),
                              desc: mySLides[0].getDesc(),
                            ),
                            Slidetil(
                              imagePath: mySLides[1].getImageAssetPath(),
                              title: mySLides[1].getTitle(),
                              desc: mySLides[1].getDesc(),
                            ),
                            Slidetil(
                              imagePath: mySLides[2].getImageAssetPath(),
                              title: mySLides[2].getTitle(),
                              desc: mySLides[2].getDesc(),
                            )
                          ],
                        ),
                      ),
                      bottomSheet: slideIndex != 2
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      controller.animateToPage(2,
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.linear);
                                    },
                                    splashColor: Colors.blue[50],
                                    child: Text(
                                      "SKIP",
                                      style: TextStyle(
                                          color: Color(0xFF0074E4),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        for (int i = 0; i < 3; i++)
                                          i == slideIndex
                                              ? _buildPageIndicator(true)
                                              : _buildPageIndicator(false),
                                      ],
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      print("this is slideIndex: $slideIndex");
                                      controller.animateToPage(slideIndex + 1,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.linear);
                                    },
                                    splashColor: Colors.blue[50],
                                    child: Text(
                                      "NEXT",
                                      style: TextStyle(
                                          color: Color(0xFF0074E4),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                authService.googleSignIn();
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) {
                                //       return (HomeScreen());
                                //     },
                                //   ),
                                // );
                              },
                              child: Container(
                                height: Platform.isIOS ? 70 : 60,
                                color: Colors.blue,
                                alignment: Alignment.center,
                                child: Text(
                                  "Log In with Google",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,),
                                ),
                              ),
                            ),
                    ),
                  )
            // RaisedButton(
            //     onPressed: () {
            //       authService.googleSignIn();
            //     },
            //     child: Text('SignIn'),
            //   ),
            ),
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
                  ),
                ),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatList(
                    userID: userDetails['uid'],
                    user: userDetails['displayName'],
                  ),
                ),
              );
            },
            child: Text('Clans'),
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

class Slidetil extends StatelessWidget {
  final String imagePath, title, desc;

  Slidetil({this.imagePath, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath),
          SizedBox(
            height: 40,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Text(desc,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))
        ],
      ),
    );
  }
}
