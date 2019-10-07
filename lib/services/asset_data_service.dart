import "dart:async" show Future;
import "package:flutter/services.dart" show rootBundle;
import "package:csv/csv.dart";
import "package:latlong/latlong.dart";

class MetlinkRoute {
  String _id;
  String _agencyId;
  String _shortName;
  String _longName;
  String _description;
  String _type;
  String _url;
  String _color;
  String _textColor;

  String get id => _id;
  String get agencyId => _agencyId;
  String get shortName => _shortName;
  String get longName => _longName;
  String get description => _description;
  String get type => _type;
  String get url => _url;
  String get color => _color;
  String get textColor => _textColor;

  MetlinkRoute.fromList(List<dynamic> list) {
    this._id = "${list[0]}";
    this._agencyId = "${list[1]}";
    this._shortName = "${list[2]}";
    this._longName = "${list[3]}";
    this._description = "${list[4]}";
    this._type = "${list[5]}";
    this._url = "${list[6]}";
    this._color = "${list[7]}";
    this._textColor = "${list[8]}";
  }
}

class AssetDataService {
  
  List<MetlinkRoute> metlinkRoutes;  

  AssetDataService() {}

  // ROUTES

  Future<void> loadMetlinkRoutes() async {
    metlinkRoutes = new List<MetlinkRoute>();
    String data = await rootBundle.loadString("assets/data/routes.txt");
    List<List<dynamic>> rows = const CsvToListConverter().convert(data);
    rows.removeAt(0);
    rows.forEach((List<dynamic> row) {
      metlinkRoutes.add(MetlinkRoute.fromList(row));
    });
    metlinkRoutes.sort((x, y) { return x.shortName.compareTo(y.shortName); });
    // metlinkRoutes = metlinkRoutes.where((x) { return x.agencyId == "NBM"; }).toList(); // NBM busses, TZM trains, UZM no idea (local?)
  }
}