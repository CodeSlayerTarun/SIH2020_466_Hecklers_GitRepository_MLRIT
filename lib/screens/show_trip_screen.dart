import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories/components/map_component.dart';

class ShowTrip extends StatefulWidget {
  final uid;
  final tripID;
  ShowTrip({this.uid, this.tripID});
  @override
  _ShowTripState createState() => _ShowTripState(tripID: tripID, userID: uid);
}

class _ShowTripState extends State<ShowTrip> {
  String userID;
  var tripID;
  Firestore _db = Firestore.instance;
  _ShowTripState({this.tripID, this.userID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: _db
              .collection('users')
              .document(userID)
              .collection('trips')
              .document(tripID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var snapshotData = snapshot.data;
              print(snapshotData);
              if (snapshotData.data.length > 0) {
                var tripData = snapshotData.data;
                print(tripData);
                DateTime startTime = tripData['startTime'].toDate();
                DateTime endTime = tripData['endTime'].toDate();
                var tripTime = endTime.difference(startTime);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child:
                          ShowMap(tripCoordinates: tripData['tripCoordinates']),
                    ),
                    Expanded(
                      flex: 4,
                      child: Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    tripData['tripName'],
                                    style: TextStyle(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        tripData['tripID'],
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.content_copy),
                                          onPressed: () {
                                            Clipboard.setData(new ClipboardData(
                                                text: tripData['tripID']));
                                            final snackBar = SnackBar(
                                              content: Text('Trip ID copied'),
                                            );

                                            // Find the Scaffold in the widget tree and use
                                            // it to show a SnackBar.
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          })
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    '${(tripData['tripDistance'].toInt().toString())} m',
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    '${startTime.day}/${startTime.month}/${startTime.year}',
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Top Speed ${(tripData['topSpeed'] * 3.6).toInt().toString()} kmph',
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Trip Time in Minutes ${tripTime.inMinutes}. In Seconds ${tripTime.inSeconds}',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Center(
                                    child: RaisedButton(
                                        color: Colors.pink[100],
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('Add Trip Photos'),
                                            Icon(Icons.add)
                                          ],
                                        ),
                                        onPressed: () {
                                          // Add photos functionality
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Text('No Trip Found');
              }
            } else {
              return Text('No such trips');
            }
          }),
    );
  }
}
