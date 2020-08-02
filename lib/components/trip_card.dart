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
                            })
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
