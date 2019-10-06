import "dart:math";
import "package:geolocator/geolocator.dart";
import "package:metlink/models/models.dart";

class ServiceLocation {
  String _direction;
  String _serviceID;
  double _lat;
  double _long;
  bool _isBehind;
  num _delayInS;
  num _delayInM;
  String _vehicleRef;
  String _destinationStopName;
  double _bearing;
  double _bearingRadians;
  String _approxAddress;
  bool _triedResolvingAddress = false;

  String _code;
  String _trimmedCode;
  String _name;
  String _mode;
  String _link;
  

  String get direction => _direction;
  String get ServiceID => _serviceID;
  double get lat => _lat;
  double get long => _long;
  bool get isBehind => _isBehind;
  num get delayInS => _delayInS;
  num get delayInM => _delayInM;
  String get vehicleRef => _vehicleRef;
  String get destinationStopName => _destinationStopName;
  double get bearing => _bearing;
  double get bearingRadians => _bearingRadians;
  String get approxAddress => _approxAddress;
  bool get triedResolvingAddress => _triedResolvingAddress;
  
  String get code => _code;
  String get trimmedCode => _trimmedCode;
  String get name => _name;
  String get mode => _mode;
  String get link => _link;

  ServiceLocation.fromMap(dynamic obj) {
    this._direction  = obj["Direction"];
    this._serviceID = obj["ServiceID"];
    this._lat  = double.parse(obj["Lat"]);
    this._long  = double.parse(obj["Long"]);
    this._isBehind  = obj["BehindSchedule"];
    this._delayInS  = obj["DelaySeconds"];
    this._delayInM  = (this._delayInS / 60).ceil();
    this._vehicleRef = obj["VehicleRef"];
    this._destinationStopName = obj["DestinationStopName"];
    this._bearing = double.parse(obj["Bearing"]);
    this._bearingRadians =  this._bearing * pi / 180; // Deg × π/180 = Radians
    
    this._code = obj["Service"]["Code"];
    this._trimmedCode = obj["Service"]["TrimmedCode"];
    this._name = obj["Service"]["Name"];
    this._mode = obj["Service"]["Mode"];
    this._link = obj["Service"]["Link"];
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