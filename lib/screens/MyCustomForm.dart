import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  String tagplaces;
  String itineary;
  Firestore _firestore = Firestore.instance;

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
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Memories",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0XFFEFF3F6),
                      borderRadius: BorderRadius.circular(100.0),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            offset: Offset(6, 2),
                            blurRadius: 6.0,
                            spreadRadius: 3.0),
                        BoxShadow(
                            color: Color.fromRGBO(255, 255, 255, 0.9),
                            offset: Offset(-6, -2),
                            blurRadius: 6.0,
                            spreadRadius: 3.0)
                      ]),
                ),
                TextField(
                  onChanged: (input) {
                    itinearyTitle = input;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Title itineary: '),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0XFFEFF3F6),
                      borderRadius: BorderRadius.circular(100.0),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            offset: Offset(6, 2),
                            blurRadius: 6.0,
                            spreadRadius: 3.0),
                        BoxShadow(
                            color: Color.fromRGBO(255, 255, 255, 0.9),
                            offset: Offset(-6, -2),
                            blurRadius: 6.0,
                            spreadRadius: 3.0)
                      ]),
                ),
                TextField(
                  onChanged: (input) {
                    itinearyTitle = input;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Tag Places: '),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration:
                      BoxDecoration(color: Color(0XFFEFF3F6), boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        offset: Offset(6, 2),
                        blurRadius: 6.0,
                        spreadRadius: 3.0),
                    BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        offset: Offset(-6, -2),
                        blurRadius: 6.0,
                        spreadRadius: 3.0)
                  ]),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (input) {
                      itinearyTitle = input;
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Itineary: '),
                  ),
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
                        color: Colors.black,
                        child: Center(
                            child: Text(
                          "SAVE",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
