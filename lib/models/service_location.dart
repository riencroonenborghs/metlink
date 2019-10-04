class ServiceLocation {
  String _direction;
  double _lat;
  double _long;
  bool _isBehind;
  num _delayInS;

  String get direction => _direction;
  double get lat => _lat;
  double get long => _long;
  bool get isBehind => _isBehind;
  num get delayInS => _delayInS;

  ServiceLocation.fromMap(dynamic obj) {
    this._direction  = obj["Direction"];
    this._lat  = double.parse(obj["Lat"]);
    this._long  = double.parse(obj["Long"]);
    this._isBehind  = obj["BehindSchedule"];
    this._delayInS  = obj["DelaySeconds"];
  }
}