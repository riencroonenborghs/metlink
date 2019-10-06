import "dart:math";
import "package:geolocator/geolocator.dart";
import "package:metlink/models/models.dart";

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
  String _approxAddress;
  bool _triedResolvingAddress = false;
  // StopDeparture _stopDeparture;

  String get direction => _direction;
  double get lat => _lat;
  double get long => _long;
  bool get isBehind => _isBehind;
  num get delayInS => _delayInS;
  String get vehicleRef => _vehicleRef;
  String get destinationStopName => _destinationStopName;
  double get bearing => _bearing;
  double get bearingRadians => _bearingRadians;
  String get approxAddress => _approxAddress;
  bool get triedResolvingAddress => _triedResolvingAddress;
  // StopDeparture get stopDeparture => _stopDeparture;

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
    // this._stopDeparture = StopDeparture.fromMap(obj["Service"]);
  }

  Future<void> getApproxAddress() async {
    if(!_triedResolvingAddress) {
      _triedResolvingAddress = true;
      List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(_lat, _long);
      placemarks.forEach((placemark) {
        _approxAddress = "${placemark.subThoroughfare} ${placemark.thoroughfare}";
      });
    }
  }
}