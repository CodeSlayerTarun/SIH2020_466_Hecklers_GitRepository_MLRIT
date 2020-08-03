import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  String itinearyTitle;
  String tagplaces;
  String itineary;
  Firestore _firestore = Firestore.instance;

  final _formKey = GlobalKey<FormState>();

  var splitList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              onChanged: (input) {
                itinearyTitle = input;
              },
              decoration: InputDecoration(labelText: 'Title itineary:'),
            ),
            TextField(
              onChanged: (value) {
                tagplaces = value;
              },
              decoration: InputDecoration(labelText: 'TagPlaces:'),
            ),
            TextField(
              onChanged: (val) {
                itineary = val;
              },
              decoration: InputDecoration(labelText: 'iternary:'),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      print(itinearyTitle);
                      print(itineary);
                      print(tagplaces);
                      if (itinearyTitle.length > 0 &&
                          itineary.length > 0 &&
                          tagplaces.length > 0) {
                        var docref =
                            _firestore.collection('clients').document();
                        docref.setData({
                          'itinearyId': docref.documentID,
                          'itinearyTitle': itinearyTitle,
                          'body': itineary,
                          'places': tagplaces,
                          'places_divided': tagplaces.split(" "),
                          'placeKey': tagplaces[0],
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
