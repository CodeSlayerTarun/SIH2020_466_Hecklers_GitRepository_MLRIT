import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class ShowMap extends StatefulWidget {
  final List<dynamic> tripCoordinates;
  ShowMap({this.tripCoordinates});
  @override
  _ShowMapState createState() => _ShowMapState(tripCoords: tripCoordinates);
}

class _ShowMapState extends State<ShowMap> {
  Completer<GoogleMapController> _controller = Completer();
  List<dynamic> tripCoords;
  List<LatLng> polylineCoords = [];
  Polyline polyline;

  _ShowMapState({this.tripCoords});

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 5.0,
  );

  @override
  void initState() {
    super.initState();
    generatePolyline();
    updatePolylines();
  }

  generatePolyline() {
    for (GeoPoint geoPoint in tripCoords) {
      var lat = geoPoint.latitude;
      var lng = geoPoint.longitude;
      polylineCoords.add(LatLng(lat, lng));
    }
  }

  void updatePolylines() async {
    GoogleMapController controller = await _controller.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(polylineCoords[0].latitude, polylineCoords[0].longitude),
        bearing: 192.8334901395799,
        tilt: 0,
        zoom: 16.0,
      )));
    }
    setState(() {
      polyline = Polyline(
        polylineId: PolylineId('1'),
        points: polylineCoords,
        color: Colors.orangeAccent,
        width: 5,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialPosition,
      polylines: Set.of((polyline != null) ? [polyline] : []),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
