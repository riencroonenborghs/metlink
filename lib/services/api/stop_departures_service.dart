import "dart:async";
import "dart:convert";

import "package:metlink/constants.dart";
import "package:metlink/services/services.dart";
import "package:metlink/models/models.dart";

class StopDeparturesService {
  var searchUrl = "$apiUrl/StopDepartures/";

  Future<dynamic> search(Stop stop) {
    var url = searchUrl + stop.code;
    return new NetworkService().get(url).then((dynamic res) {
      var body = json.decode(res.body);
      List<TransportService> transportServices = List<TransportService>();
      body["Services"].forEach((data) {
        transportServices.add(TransportService.fromMap(data["Service"]));
      });
      return transportServices;
    });
  }
}