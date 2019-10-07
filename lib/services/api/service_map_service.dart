import "dart:async";
import "dart:convert";

import "package:metlink/constants.dart";
import "package:metlink/models/models.dart";
import "package:metlink/services/services.dart";

class ServiceMapService {
  var searchUrl = "$apiUrl/ServiceMap/";

  Future<ServiceMap> search(String code) {
    var url = searchUrl + code;
    return new NetworkService().get(url).then((dynamic res) {
      var body = json.decode(res.body);
      return ServiceMap.fromMap(body);
    });
  }
}