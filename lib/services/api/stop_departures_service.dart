import "dart:async";
import "dart:convert";

import "package:metlink/constants.dart";
import "package:metlink/services/services.dart";
import "package:metlink/models/models.dart";

class StopDeparturesService {
  var searchUrl = "$apiUrl/StopDepartures/";

  Future<List<StopDeparture>> search(Stop stop) {
    var url = searchUrl + stop.code;
    return new NetworkService().get(url).then((dynamic res) {
      var body = json.decode(res.body);
      List<StopDeparture> stopDepartures = List<StopDeparture>();
      print(body);
      body["Services"].forEach((data) {
        stopDepartures.add(StopDeparture.fromMap(data["Service"]));
      });
      stopDepartures.sort((x,y) { return  x.code.compareTo(y.code); });
      return stopDepartures;
    });
  }
}