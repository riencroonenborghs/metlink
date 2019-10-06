import "dart:async";
import "dart:convert";

import "package:metlink/constants.dart";
import "package:metlink/services/services.dart";
import "package:metlink/models/models.dart";

class ServiceLocationService {
  var searchUrl = "$apiUrl/ServiceLocation/";

  Future<dynamic> search(String query) {
    var url = searchUrl + query;
    return new NetworkService().get(url).then((dynamic res) {
      var body = json.decode(res.body);
      List<ServiceLocation> serviceLocations = List<ServiceLocation>();
      body["Services"].forEach((data) {
        serviceLocations.add(ServiceLocation.fromMap(data));
      });
      return serviceLocations;
    });
  }

  Future<ServiceLocation> forStopDeparture(StopDeparture stopDeparture) {
    var url = searchUrl + stopDeparture.code;
    return new NetworkService().get(url).then((dynamic res) {
      var body = json.decode(res.body);
      List<ServiceLocation> serviceLocations = List<ServiceLocation>();
      body["Services"].forEach((data) {
        serviceLocations.add(ServiceLocation.fromMap(data));
      });
      return serviceLocations.where((item) { return item.vehicleRef == stopDeparture.vehicleRef; }).first;
    });
  }
}