import "dart:async" show Future;
import "package:flutter/services.dart" show rootBundle;
import "package:csv/csv.dart";
import "package:latlong/latlong.dart";
import "package:metlink/models/models.dart";

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