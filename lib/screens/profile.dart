import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memories/services/auth.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Firestore _db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
              stream: _db.collection('users').document(user.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var snapshotData = snapshot.data;
                  if (snapshotData.data.length > 0) {
                    var userDetails = snapshotData.data;
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50.0,
                                    ),
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(userDetails['photoURL']),
                                      radius: 80.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 15.0),
                                      child: Text(
                                        userDetails['displayName'],
                                        style: TextStyle(fontSize: 30.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 15.0),
                                      child: Text(
                                        userDetails['email'],
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            userDetails['uid'],
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          IconButton(
                                              icon:
                                                  FaIcon(FontAwesomeIcons.copy),
                                              onPressed: () {
                                                Clipboard.setData(
                                                    new ClipboardData(
                                                        text: userDetails[
                                                            'uid']));
                                                final snackBar = SnackBar(
                                                  content:
                                                      Text('UserID ID copied'),
                                                );

                                                // Find the Scaffold in the widget tree and use
                                                // it to show a SnackBar.
                                                Scaffold.of(context)
                                                    .showSnackBar(snackBar);
                                              })
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${userDetails['totalDistance'].toString()} kms covered',
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              RawMaterialButton(
                                elevation: 3.0,
                                fillColor: Colors.white,
                                onPressed: () {
                                  authService.signOut();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text('Sign Out'),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.powerOff,
                                      size: 25.0,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(15.0),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text('No such user found');
                  }
                } else {
                  return Text('No such user found');
                }
              })),
    );
  }
}
