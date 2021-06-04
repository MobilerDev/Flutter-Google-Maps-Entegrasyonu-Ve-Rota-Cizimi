import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

double _originLatitude = 38.4382955939104;
double _originLongitude = 27.141358956227965;
double _destLatitude = 38.422733197746986;
double _destLongitude =  27.129490953156576;

class _MapsState extends State<Maps> {
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  MapType _currentMapType = MapType.normal;
  GoogleMapController _controller;
  static final CameraPosition _initalCameraPosition = CameraPosition(
    target: LatLng(_originLatitude, _originLongitude),
    zoom: 15,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: goToLoc,
        child: Icon(Icons.map),
      ),
      body: GoogleMap(
        polylines: Set<Polyline>.of(polylines.values),
        markers: _cretaeMarker(),
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _initalCameraPosition,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }

  Set<Marker> _cretaeMarker() {
    return <Marker>[
      Marker(
          infoWindow: InfoWindow(title: "Kordon Alsancak"),
          markerId: MarkerId("asdasd"),
          position: _initalCameraPosition.target,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)),
      Marker(
          infoWindow: InfoWindow(title: "Ev"),
          markerId: MarkerId("asdasdd"),
          position: LatLng(38.392300, 27.047840),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
      Marker(
          infoWindow: InfoWindow(title: "Konak Pier"),
          markerId: MarkerId("asdsasdd"),
          position: LatLng(38.422733197746986, 27.129490953156576),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
    ].toSet();
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  goToLoc() {
    _controller
        .animateCamera(CameraUpdate.newLatLng(LatLng(38.392300, 27.047840)));
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCzFlbNYhBQBRb8zDQsrgVj0TazijIqlpA",
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print("Hata" + result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.pink,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }
}
