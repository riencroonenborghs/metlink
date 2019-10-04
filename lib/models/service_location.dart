import "package:metlink/models/models.dart";

class ServiceLocation {
  String _direction;
  double _lat;
  double _long;
  bool _isBehind;
  num _delayInS;
  String _vehicleRef;
  String _destinationStopName;
  TransportService _transportService;

  String get direction => _direction;
  double get lat => _lat;
  double get long => _long;
  bool get isBehind => _isBehind;
  num get delayInS => _delayInS;
  String get vehicleRef => _vehicleRef;
  String get destinationStopName => _destinationStopName;
  TransportService get transportService => _transportService;

  ServiceLocation.fromMap(dynamic obj) {
    this._direction  = obj["Direction"];
    this._lat  = double.parse(obj["Lat"]);
    this._long  = double.parse(obj["Long"]);
    this._isBehind  = obj["BehindSchedule"];
    this._delayInS  = obj["DelaySeconds"];
    this._vehicleRef = obj["VehicleRef"];
    this._destinationStopName = obj["DestinationStopName"];
    this._transportService = TransportService.fromMap(obj["Service"]);
  }
}