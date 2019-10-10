import "package:flutter_map/flutter_map.dart";
import "package:latlong/latlong.dart";
import "package:geolocator/geolocator.dart";
import "package:flutter/material.dart";

String apiUrl = "https://www.metlink.org.nz/api/v1";
String busTimetablesUrl = "https://www.metlink.org.nz/timetables/bus";
String mainTitle = "Metlink Bus Tracker";

Marker beehiveMarker = Marker(
  width: 45.0,
  height: 45.0,
  point: LatLng(-41.2784228, 174.776692),
  builder: (ctx) => Container(
    child: Icon(Icons.location_on)
  )
);

Position homePosition = Position(
  latitude: -41.2845402,
  longitude: 174.7242675,
  timestamp: null,
  mocked: null,
  accuracy: null,
  altitude: null,
  heading: null,
  speed: null,
  speedAccuracy: null
);
unsetHomePosition() { homePosition = null; }

Color routeColor = Color.fromRGBO(237, 130, 39, 1);