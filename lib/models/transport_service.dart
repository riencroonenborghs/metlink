class TransportService {
  String _code;
  String _name;
  String _link;

  String get code => _code;
  String get name => _name;
  String get link => _link;

  TransportService.fromMap(dynamic obj) {
    this._code  = obj["Code"];
    this._name  = obj["Name"];
    this._link  = obj["Link"];
  }
}