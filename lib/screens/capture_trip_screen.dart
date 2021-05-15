import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:latlong/latlong.dart' as LatLngCal;
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class CaptureTrip extends StatefulWidget {
  static String route = 'CaptureTrip';
  @override
  _CaptureTripState createState() => _CaptureTripState();
}

class _CaptureTripState extends State<CaptureTrip> {
  Completer<GoogleMapController> _controller = Completer();
  Location _location = Location();
  StreamSubscription _locationSubscription;
  final Firestore _db = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  // Using Latlong library
  final LatLngCal.Distance _distance = new LatLngCal.Distance();

  // Trip specific data
  LocationData _pastCoords;
  DateTime _endTime;
  DateTime _startTime;
  List<GeoPoint> _tripCoordinates = [];
  double _tripDistance = 0;
  double _topSpeed = 0;
  bool _isTripping = false;
  String _tripName = 'TempName';
  String uid;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  Marker marker;
  final Map<String, Marker> _markers = {};
  Circle circle;

  bool isBroadcasting = false;
  StreamSubscription<List<DocumentSnapshot>> broadcastStream;

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  PolylinePoints direction = PolylinePoints();

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
    getLocationPermissions();
    getLocation();
  }

  Future<Uint8List> loadMarkerImage() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load('assets/images/marker.png');
    return byteData.buffer.asUint8List();
  }

  void getLocationPermissions() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void getLocation() async {
    try {
      Uint8List markerImg = await loadMarkerImage();
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = _location.onLocationChanged
          .listen((LocationData currentLocation) async {
        // Capture coords if _isTripping is true, else update map
        if (_isTripping) {
          if (_pastCoords != null) {
            double distance = _distance.distance(
                LatLngCal.LatLng(_pastCoords.latitude, _pastCoords.longitude),
                LatLngCal.LatLng(
                    currentLocation.latitude, currentLocation.longitude));
            if (distance > 3.0) {
              print(currentLocation);
              print(distance);
              _tripCoordinates.add(GeoPoint(
                  currentLocation.latitude, currentLocation.longitude));
              _tripDistance += distance;
              if (currentLocation.speed != null ||
                  currentLocation.speed > 0.0) {
                if (currentLocation.speed > _topSpeed) {
                  _topSpeed = currentLocation.speed;
                }
              }
              _pastCoords = currentLocation;
            }
          } else {
            _pastCoords = currentLocation;
          }
        }

        GoogleMapController controller = await _controller.future;
        if (controller != null) {
          controller
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            bearing: 192.8334901395799,
            tilt: 0,
            zoom: 18.0,
          )));
          updateMarkerAndCirle(
              newLocationData: currentLocation, markerImgData: markerImg);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // void updatePolyLine(LatLng dest) async {
  //   LocationData currentLocation = await _location.getLocation();
  //   var origin =
  //       PointLatLng(currentLocation.latitude, currentLocation.longitude);
  //   var destination = PointLatLng(dest.latitude, dest.longitude);
  //   PolylineResult result = await direction.getRouteBetweenCoordinates(
  //       'API', origin, destination,
  //       travelMode: TravelMode.driving);
  //   print('Google Points');
  //   print(result.points);
  // }

  void updateMarkerAndCirle(
      {LocationData newLocationData, Uint8List markerImgData}) {
    LatLng latlng = LatLng(newLocationData.latitude, newLocationData.longitude);
    setState(() {
      marker = Marker(
        markerId: MarkerId('user'),
        position: latlng,
        rotation: newLocationData.heading,
        draggable: false,
        zIndex: 2,
        anchor: Offset(0.5, 0.6),
        flat: true,
        icon: BitmapDescriptor.fromBytes(markerImgData),
      );
      _markers['user'] = marker;
      circle = Circle(
        circleId: CircleId('userAccuracy'),
        radius: newLocationData.accuracy,
        zIndex: 1,
        strokeColor: Color(0xFF1ABC9C),
        strokeWidth: 1,
        center: latlng,
        fillColor: Color(0xFF1ABC9C).withAlpha(20),
      );
    });
  }

  Future<void> updateTotalDistance() async {
    var userDetails;
    DocumentReference ref = _db.collection('users').document(uid);
    await ref.get().then((value) {
      userDetails = value.data;
    });
    var totalDistance = userDetails['totalDistance'];
    totalDistance += _tripDistance;
    return ref.updateData({'totalDistance': totalDistance});
  }

  void stopTrip() async {
    _endTime = DateTime.now();
    _isTripping = false;
    try {
      var docRef =
          _db.collection('users').document(uid).collection('trips').document();
      docRef.setData({
        'tripID': docRef.documentID,
        'tripName': _tripName,
        'startTime': _startTime,
        'endTime': _endTime,
        'tripDistance': _tripDistance,
        'topSpeed': _topSpeed,
        'tripCoordinates': _tripCoordinates,
      });
      await updateTotalDistance();
      print('Data Added');
    } catch (e) {
      print(e);
    }
    _tripCoordinates = [];
    _tripDistance = 0;
    _topSpeed = 0.0;
  }

  loadBroadcastMarkers() async {
    LocationData currentPosition = await _location.getLocation();
    var ref = _db.collection('needHelp');
    GeoFirePoint center =
        GeoFirePoint(currentPosition.latitude, currentPosition.longitude);
    broadcastStream = geo
        .collection(collectionRef: ref)
        .within(
            center: center, radius: 50.0, field: 'position', strictMode: true)
        .listen(
      (event) {
        if (event.length > 0) {
          updateHelpMarkers(documentList: event);
        } else {
          setState(() {
            _markers.removeWhere((key, value) => key != 'user');
          });
        }
      },
    );
  }

  void updateHelpMarkers({List<DocumentSnapshot> documentList}) async {
    setState(() {
      _markers.removeWhere((key, value) => key != 'user');
    });
    documentList.forEach((DocumentSnapshot document) {
      if (document.data.length > 0) {
        GeoPoint pos = document.data['position']['geopoint'];
        var marker = Marker(
          markerId: MarkerId(document.data['uid']),
          position: LatLng(pos.latitude, pos.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow:
              InfoWindow(title: document.data['name'], snippet: 'Need Help'),
          zIndex: 5,
        );
        setState(() {
          _markers[document.data['uid']] = marker;
        });
      }
    });
  }

  void broadcastLocation() async {
    isBroadcasting = true;
    print('Broadcasting User location');
    LocationData currentPosition = await _location.getLocation();
    GeoFirePoint myLocation = geo.point(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude);
    var userDetails;
    DocumentReference ref = _db.collection('users').document(uid);
    await ref.get().then((value) {
      userDetails = value.data;
    });
    _db.collection('needHelp').document(uid).setData({
      'uid': uid,
      'name': userDetails['displayName'],
      'position': myLocation.data
    }, merge: true);
  }

  void stopBroadcasting() async {
    isBroadcasting = false;
    await _db.collection('needHelp').document(uid).delete();
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    if (broadcastStream != null) {
      broadcastStream.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    uid = user.uid;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              markers: _markers.values.toSet(),
              circles: Set.of((circle != null) ? [circle] : []),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                loadBroadcastMarkers();
              },
              // onTap: (argument) {
              //   updatePolyLine(argument);
              // },
            ),
            Positioned(
              bottom: 20,
              left: 50,
              child: Column(
                children: <Widget>[
                  (!_isTripping)
                      ? Container(
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 150,
                                    child: SizedBox(
                                      width: 30.0,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Trip Name',
                                          fillColor: Colors.white,
                                        ),
                                        onChanged: (value) {
                                          _tripName = value;
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50.0,
                                  ),
                                  RaisedButton(
                                    color: Colors.greenAccent,
                                    child: Text('Start Trip'),
                                    onPressed: () {
                                      _isTripping = true;
                                      _startTime = DateTime.now();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : RaisedButton(
                          color: Colors.redAccent,
                          child: Text('Stop Trip'),
                          onPressed: () {
                            stopTrip();
                          },
                        ),
                ],
              ),
            ),
            Positioned(
              top: 10.0,
              right: 10.0,
              child: (!isBroadcasting)
                  ? RaisedButton(
                      color: Colors.red,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FaIcon(
                            FontAwesomeIcons.exclamationTriangle,
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Help Me'),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {
                        broadcastLocation();
                      })
                  : RaisedButton(
                      color: Colors.yellow,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FaIcon(
                            FontAwesomeIcons.exclamationCircle,
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Stop Broadcast'),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.yellow)),
                      onPressed: () {
                        stopBroadcasting();
                      }),
            ),
          ],
        ),
      ),
    );
  }
}