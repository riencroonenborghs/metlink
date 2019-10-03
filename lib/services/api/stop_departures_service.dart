import "dart:async";
import "dart:convert";

import "package:metlink/constants.dart";
import "package:metlink/services/services.dart";

class StopDeparturesService {
  var searchUrl = "$apiUrl/StopDepartures/";

  Future<dynamic> search(String query) {
    var url = searchUrl + query;
    return new NetworkService().get(url).then((dynamic res) {
      var body = json.decode(res.body);
      print(body);
      return body;
    });
  }
}