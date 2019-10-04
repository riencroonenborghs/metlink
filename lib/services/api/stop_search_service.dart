import "dart:async";
import "dart:convert";

import "package:metlink/constants.dart";
import "package:metlink/models/models.dart";
import "package:metlink/services/services.dart";

class StopSearchService {
  var searchUrl = "$apiUrl/StopSearch/";

  Future<dynamic> search(String query) {
    var url = searchUrl + query;
    return new NetworkService().get(url).then((dynamic res) {
      var body = json.decode(res.body);
      List<Stop> stops = List<Stop>();
      body.forEach((data) {
        stops.add(Stop.fromMap(data));
      });
      stops.sort((x,y) { return  x.code.compareTo(y.code); });
      return stops;
    });
  }
}