import "package:flutter_map/flutter_map.dart";
import "package:latlong/latlong.dart";
import "package:flutter/material.dart";

String apiUrl = "https://www.metlink.org.nz/api/v1";

Marker beehiveMarker = Marker(
  width: 45.0,
  height: 45.0,
  point: LatLng(-41.2784228, 174.776692),
  builder: (ctx) => Container(
    child: Icon(Icons.location_on)
  )
);