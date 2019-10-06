class StopDeparture {
  DateTime _aimedArrival;
  DateTime _aimedDeparture;
  String _departureStatus;
  String _destinationStopID;
  String _destinationStopName;
  String _direction;
  DateTime _displayDeparture;
  num _displayDepartureSeconds;
  DateTime _expectedDeparture;
  bool _isRealtime;
  String _operatorRef;
  String _originStopID;
  String _originStopName;  
  String _serviceID;
  String _vehicleFeature;
  String _vehicleRef;
  // Service
  String _code;
  String _link;
  String _mode;
  String _name;
  String _trimmedCode;

  DateTime get aimedArrival => _aimedArrival;
  DateTime get aimedDeparture => _aimedDeparture;
  String get departureStatus => _departureStatus;
  String get destinationStopID => _destinationStopID;
  String get destinationStopName => _destinationStopName;
  String get direction => _direction;
  DateTime get displayDeparture => _displayDeparture;
  num get displayDepartureSeconds => _displayDepartureSeconds;
  DateTime get expectedDeparture => _expectedDeparture;
  bool get isRealtime => _isRealtime;
  String get operatorRef => _operatorRef;
  String get originStopID => _originStopID;
  String get originStopName => _originStopName;  
  String get serviceID => _serviceID;
  String get vehicleFeature => _vehicleFeature;
  String get vehicleRef => _vehicleRef;
  // Service
  String get code => _code;
  String get link => _link;
  String get mode => _mode;
  String get name => _name;
  String get trimmedCode => _trimmedCode;

  StopDeparture.fromMap(dynamic object) {
    this._aimedArrival = object["AimedArrival"] != null ? DateTime.parse(object["AimedArrival"]).toLocal() : null;
    this._aimedDeparture = object["AimedDeparture"] != null ? DateTime.parse(object["AimedDeparture"]).toLocal() : null;
    this._departureStatus = object["DepartureStatus"];
    this._destinationStopID = object["DestinationStopID"];
    this._destinationStopName = object["DestinationStopName"];
    this._direction = object["Direction"];
    this._displayDeparture = object["DisplayDeparture"] != null ? DateTime.parse(object["DisplayDeparture"]).toLocal() : null;
    this._displayDepartureSeconds = object["DisplayDepartureSeconds"];
    this._expectedDeparture = object["ExpectedDeparture"] != null ? DateTime.parse(object["ExpectedDeparture"]).toLocal() : null;
    this._isRealtime = object["IsRealtime"];
    this._operatorRef = object["OperatorRef"];
    this._originStopID = object["OriginStopID"];
    this._originStopName = object["OriginStopName"];  
    this._serviceID = object["ServiceID"];
    this._vehicleFeature = object["VehicleFeature"];
    this._vehicleRef = object["VehicleRef"];

    this._code = object["Service"]["Code"];
    this._link = object["Service"]["Link"];
    this._mode = object["Service"]["Mode"];
    this._name = object["Service"]["Name"];
    this._trimmedCode = object["Service"]["TrimmedCode"];
  }
}