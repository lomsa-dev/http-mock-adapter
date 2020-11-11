class Request {
  final RequestMethod method;
  final dynamic data;
  final dynamic headers;

  const Request({this.method = RequestMethod.GET, this.data, this.headers});
}

class RequestMatcher {
  final Request request;
  final RequestHandler requestHandler;

  RequestMatcher(this.request, this.requestHandler);
}

enum RequestMethod {
  GET,
  HEAD,
  POST,
  PUT,
  DELETE,
  CONNECT,
  OPTIONS,
  TRACE,
  PATCH
}

class RequestHandler {
  int statusCode;
  final route;

  Map<int, Map<String, dynamic>> requestMap = {};

  RequestHandler(this.route);

  void reply(int statusCode, Map<String, dynamic> data) {
    this.statusCode = statusCode;

    requestMap[this.statusCode] = data;
  }
}
