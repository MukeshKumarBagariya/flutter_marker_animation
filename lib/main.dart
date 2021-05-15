import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

const kMarkerId = MarkerId('MarkerId1');
const kMarkerId1 = MarkerId('MarkerId2');
const kDuration = Duration(seconds: 1);
const kSantoDomingo = CameraPosition(target: kStartPosition, zoom: 17);
const kStartPosition = LatLng(28.436970000000002, 77.11272000000001);
const kLocations = [
  kStartPosition,
  LatLng(28.43635, 77.11289000000001),
  LatLng(28.4353, 77.11317000000001),
  LatLng(28.435280000000002, 77.11332),
  LatLng(28.435350000000003, 77.11368),
  LatLng(28.4356, 77.11498),
  LatLng(28.435660000000002, 77.11519000000001),
  LatLng(28.43568, 77.11521),
  LatLng(28.436580000000003, 77.11499),
  LatLng(28.436590000000002, 77.11507),
];
var kLocations2 = kLocations.reversed.toList();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;

  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final markers1 = <MarkerId, Marker>{};
  final markers = <MarkerId, Marker>{};
  final controller = Completer<GoogleMapController>();
  BitmapDescriptor sourceIcon;
  BitmapDescriptor customIcon;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  final stream = Stream.periodic(kDuration, (count) => kLocations[count]).take(kLocations.length);
  final stream2 = Stream.periodic(kDuration, (count) => kLocations2[count]).take(kLocations2.length);

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blueAccent, points: kLocations, width: 4);
    polylines[id] = polyline;
    setState(() {});
  }

  void newLocationUpdate(LatLng latLng) {
    var marker = RippleMarker(
      markerId: kMarkerId,
      position: latLng,
      ripple: false,
    );
    setState(() => markers1[kMarkerId] = marker);
  }


  void newLocationUpdate1(LatLng latLng) {
    var marker1 = RippleMarker(
      markerId: kMarkerId1,
      position: latLng,
      ripple: false,
    );
    setState(() => markers1[kMarkerId1] = marker1);
  }

  @override
  void initState() {
    stream.forEach((value) => newLocationUpdate(value));
    stream2.forEach((value) => newLocationUpdate1(value));
    super.initState();
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Animarker(
          curve: Curves.ease,
          mapId: controller.future.then<int>((value) => value.mapId),
          markers: markers1.values.toSet(),
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: kSantoDomingo,
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (gController) => controller.complete(gController),
          ),
        )
    );
  }
}
