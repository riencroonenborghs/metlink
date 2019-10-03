import "dart:async";
import "package:http/http.dart" as http;

class NetworkService {
  // next three lines makes this class a Singleton
  static NetworkService _instance = new NetworkService.internal();
  NetworkService.internal();
  factory NetworkService() => _instance;

  Future<http.Response> get(String url) {
    return http.get(url).then((http.Response response) {
      return handleResponse(response);
    });
  }

  http.Response handleResponse(http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode != 200) {
      throw new Exception("Error while fetching data");
    }

    return response;
  }
}