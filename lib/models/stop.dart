class Stop {
  int _id;
  String _name;
  String _code;
  String _farezone; // Farezone
  double _lat;
  double _long;

  int get id => _id;
  String get name => _name;
  String get code => _code;
  String get farezone => _farezone;
  double get lat => _lat;
  double get long => _long;

  Stop.fromMap(dynamic obj) {
    this._id    = obj["ID"];
    this._name  = obj["Name"];
    this._code  = obj["Sms"];
    this._farezone = obj["Farezone"];
    this._lat = obj["Lat"];
    this._long = obj["Long"];
  }

  Stop.fromServiceMap(dynamic obj) {
    this._code = obj["Sms"];
    List<String> latAndLng = obj["LatLng"].split(",");
    this._lat = double.parse(latAndLng[0]);
    this._long = double.parse(latAndLng[1]);
  }
}