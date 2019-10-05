import "dart:async";
import "dart:convert";

import "package:metlink/constants.dart";
import "package:metlink/models/models.dart";
import "package:metlink/services/services.dart";

class StopService {
  var searchUrl = "$apiUrl/Stop/";

  Future<Stop> search(String code) {
    var url = searchUrl + code;
    return new NetworkService().get(url).then((dynamic res) {
      var body = json.decode(res.body);
      return Stop.fromMap(body);
    });
  }
}