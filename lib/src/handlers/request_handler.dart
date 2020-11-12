import '../request.dart';

/// Combinator of [Request] and [RequestHandler] to easily access them.
class RequestMatcher {
  /// This is a request sent by the the client.
  final Request request;

  /// This is a request handler that processes accompanied request.
  final RequestHandler requestHandler;

  RequestMatcher(this.request, this.requestHandler);
}

/// The handler of requests sent by clients.
class RequestHandler {
  /// An HTTP status code such as - `200`, `404`, `500`, etc.
  int statusCode;

  /// Route of the sent request.
  final String route;

  /// Map of <[statusCode], <[route], <[data]>>.
  Map<int, Map<String, dynamic>> requestMap = {};

  RequestHandler(this.route);

  /// Stores response.data in [requestMap].
  void reply(int statusCode, Map<String, dynamic> data) {
    this.statusCode = statusCode;

    requestMap[this.statusCode] = data;
  }
}
