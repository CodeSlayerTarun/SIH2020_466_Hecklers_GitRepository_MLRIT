import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories/components/map_component.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

class ShowTrip extends StatefulWidget {
  final uid;
  final tripID;
  ShowTrip({this.uid, this.tripID});
  @override
  _ShowTripState createState() => _ShowTripState(tripID: tripID, userID: uid);
}

class _ShowTripState extends State<ShowTrip> {
  File _image;
  
  String userID;
  var tripID;
  Firestore _db = Firestore.instance;
  _ShowTripState({this.tripID, this.userID});

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('_image: $_image');
    });
  }

  // Future _getImage(bool isCamera) async{
  //   if(isCamera){
  //     var image = await ImagePicker.pickImage(source: ImageSource.camera);
  //   }else{
  //     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   }
  //   setState(() {
  //     _image = image;
  //     print('_image: $_image');
  //   }
  // }

  // String _downloadUrl;
  // bool _uploaded;

  // StorageReference _reference = FirebaseStorage.instance.ref().child('userID');
  // Future uploadImage() async {
  //   StorageUploadTask uploadTask = _reference.putFile(_image);
  //   Future<StorageTaskSnapshot> taskSnapshot = await uploadTask.onComplete;
  //   setState(() {
  //     _uploaded = true;
  //   });
  // }

  // Future downloadImage() async {
  //   String downloadAddress = await _reference.getDownloadURL();
  //   setState(() {
  //     _downloadUrl =  downloadAddress;
  //   });
  // }

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
                                    child: Column(
                                      children: <Widget>[
                                        MaterialButton(
                                          height: 20,
                                          minWidth: 20,
                                          color: Colors.pink[100],
                                          child: Icon(Icons.add_a_photo),
                                          onPressed: _getImage,
                                          // _getImage(true),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_image != null) ...[
                                    Image.file(_image,
                                        height: 300.0, width: 300.0),
                                    RaisedButton(
                                      child: Text('upload '),
                                      onPressed: () {
                                        // uploadImage();
                                      },
                                    ),
                                    // _uploaded = false ? 
                                  ]
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
