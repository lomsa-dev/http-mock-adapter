import 'package:http_mock_adapter/http_mock_adapter.dart';

/// The handler of requests sent by clients.
class RequestHandler {
  /// An HTTP status code such as - `200`, `404`, `500`, etc.
  int statusCode;

  /// Map of <[statusCode], [data]>.
  final Map<int, dynamic> requestMap = {};

  /// Stores [response.data] in [requestMap] and returns [DioAdapter]
  /// the latter which is utilized for method chaining.
  DioAdapter reply(int statusCode, dynamic data) {
    this.statusCode = statusCode;

    requestMap[this.statusCode] = data;

    return DioAdapter();
  }
}
