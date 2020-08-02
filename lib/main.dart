import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());
final _firestore = Firestore.instance;
String tagplaces;
String itineary;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Memories';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  String itinearyTitle;
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  var splitList = [];

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
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
            onChanged: (input) {
              itineary = input;
            },
            decoration: InputDecoration(labelText: 'iternary:'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                List<String> places = tagplaces.split('');

                List<String> indexList = [];
                for (int i = 0; i < splitList.length; i++) {
                  for (int y = 1; y < splitList[i].length + 1; y++) {
                    indexList.add(splitList[i].substring(0, y).toLowerCase());
                  }
                }

                print(itinearyTitle);
                print(itineary);
                print(tagplaces);
                if (itinearyTitle.length > 0 &&
                    itineary.length > 0 &&
                    places.length > 0) {
                  var docref = _firestore.collection('stored_data').document();
                  docref.setData({
                    'itinearyId': docref.documentID,
                    'itinearyTitle': itinearyTitle,
                    'itineary': itineary,
                    'tagPlaces': tagplaces,
                  });
                }

                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
