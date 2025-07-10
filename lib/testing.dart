import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapExample extends StatefulWidget {
  @override
  _GoogleMapExampleState createState() => _GoogleMapExampleState();
}

class _GoogleMapExampleState extends State<GoogleMapExample> {
  LatLng? tappedPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Map Tap Example')),
      body: GoogleMap(

        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // San Francisco
          zoom: 12,
        ),
        rotateGesturesEnabled: true,
        zoomControlsEnabled: false,
        mapToolbarEnabled: true,

       // myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (LatLng position) {
          print('Tapped at: ${position.latitude}, ${position.longitude}');
          setState(() {
            tappedPoint = position;
          });
        },
      ),
    );
  }

}