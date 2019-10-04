class Stop {
  int _id;
  String _name;
  String _code;

  int get id => _id;
  String get name => _name;
  String get code => _code;

  Stop.fromMap(dynamic obj) {
    this._id    = obj["ID"];
    this._name  = obj["Name"];
    this._code  = obj["Sms"];
  }
}