import 'package:flutter/material.dart';
import 'package:memories/components/map_component.dart';
import 'package:memories/screens/show_trip_screen.dart';

class TripCard extends StatefulWidget {
  final tripDetails;
  final userID;
  TripCard({this.tripDetails, this.userID});
  @override
  _TripCardState createState() =>
      _TripCardState(userid: userID, tripData: tripDetails);
}

class _TripCardState extends State<TripCard> {
  var tripData;
  var userid;
  _TripCardState({this.tripData, this.userid});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: ShowMap(
                tripCoordinates: tripData['tripCoordinates'],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          tripData['tripName'],
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.open_in_new),
                          onPressed: () {
                            print('Button Pressed');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowTrip(
                                        uid: userid,
                                        tripID: tripData['tripID'])));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
