import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/components/trip_card.dart';

class ViewTrip extends StatefulWidget {
  static String route = 'ViewTrip';
  final String uid;
  ViewTrip({this.uid});
  @override
  _ViewTripState createState() => _ViewTripState(userid: uid);
}

class _ViewTripState extends State<ViewTrip> {
  String userid;
  final Firestore _db = Firestore.instance;

  _ViewTripState({this.userid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Trips.',
                  style: TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: _db
                        .collection('users')
                        .document(userid)
                        .collection('trips')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var trips = snapshot.data.documents;
                        if (trips.length > 0) {
                          List<TripCard> tripsDetails = [];
                          for (var trip in trips) {
                            tripsDetails.add(
                              TripCard(
                                tripDetails: trip.data,
                              ),
                              // Text(trip.data.toString()),
                            );
                          }
                          return ListView(
                            children: tripsDetails,
                          );
                        } else {
                          return Text('No user trips');
                        }
                        // return Text('Hello');
                      } else {
                        return Text('No trips stored yet');
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
