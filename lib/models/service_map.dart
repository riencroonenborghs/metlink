import "package:flutter/material.dart";
import "package:latlong/latlong.dart";
import "package:flutter_map/flutter_map.dart";

import "package:metlink/models/models.dart";

class ServiceMap {
  String _code;
  List<List<LatLng>> _paths;
  List<Stop> _stops;

  String get code => _code;
  List<List<LatLng>> get paths => _paths;
  List<Stop> get stops => _stops;

  ServiceMap.fromMap(dynamic obj) {
    this._code = obj["Code"];
    this._paths = new List<List<LatLng>>();
    obj["RouteMaps"].forEach((data) {
      List<LatLng> path = new List<LatLng>();
      data["Path"].forEach((pathData) {
        List<String> latAndLng = pathData.split(",");
        path.add(
          new LatLng(
            double.parse(latAndLng[0]),
            double.parse(latAndLng[1])
          )
        );
      });
      this._paths.add(path);
    });
    this._stops = new List<Stop>();
    obj["StopLocations"].forEach((dynamic data) {
      this._stops.add(Stop.fromServiceMap(data));
    });
  }

  List<Polyline> generatePolylines(Color color) {
    List<Polyline> polyLines = new List<Polyline>();
    this._paths.forEach((List<LatLng> path) {
      polyLines.add(
        Polyline(
          points: path,
          strokeWidth: 4.0,
          color: color
        )
      );
    });
    return polyLines;
  }
}