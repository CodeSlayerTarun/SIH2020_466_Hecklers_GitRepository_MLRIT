import 'package:flutter/material.dart';
import 'package:memories/components/map_component.dart';

class TripCard extends StatefulWidget {
  final tripDetails;
  TripCard({this.tripDetails});
  @override
  _TripCardState createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  var tripData;
  @override
  void initState() {
    super.initState();
    tripData = widget.tripDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
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
                children: <Widget>[
                  Text(tripData['tripName']),
                  Text((tripData['tripDistance']).toString()),
                  Text((tripData['topSpeed']).toString()),
                  Text(tripData['endTime'].toString()),
                  Text(tripData['endTime'].toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
