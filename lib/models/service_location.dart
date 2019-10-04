import "package:metlink/models/models.dart";
import "dart:math";

class ServiceLocation {
  String _direction;
  double _lat;
  double _long;
  bool _isBehind;
  num _delayInS;
  String _vehicleRef;
  String _destinationStopName;
  double _bearing;
  double _bearingRadians;
  StopDeparture _stopDeparture;

  String get direction => _direction;
  double get lat => _lat;
  double get long => _long;
  bool get isBehind => _isBehind;
  num get delayInS => _delayInS;
  String get vehicleRef => _vehicleRef;
  String get destinationStopName => _destinationStopName;
  double get bearing => _bearing;
  double get bearingRadians => _bearingRadians;
  StopDeparture get stopDeparture => _stopDeparture;

  ServiceLocation.fromMap(dynamic obj) {
    this._direction  = obj["Direction"];
    this._lat  = double.parse(obj["Lat"]);
    this._long  = double.parse(obj["Long"]);
    this._isBehind  = obj["BehindSchedule"];
    this._delayInS  = obj["DelaySeconds"];
    this._vehicleRef = obj["VehicleRef"];
    this._destinationStopName = obj["DestinationStopName"];
    this._bearing = double.parse(obj["Bearing"]);
    this._bearingRadians =  this._bearing * pi / 180; // Deg × π/180 = Radians
    this._stopDeparture = StopDeparture.fromMap(obj["Service"]);
  }
}