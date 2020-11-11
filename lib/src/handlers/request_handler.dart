/// [Request] class contains members to hold network request information.
class Request {
  /// An HTTP method such as [RequestMethod.GET] or [RequestMethod.POST].
  final RequestMethod method;

  /// The payload.
  final dynamic data;

  /// Headers to encompass content-types.
  final dynamic headers;

  const Request({this.method = RequestMethod.GET, this.data, this.headers});
}

/// Combinator of [Request] and [RequestHandler] to easily access them.
class RequestMatcher {
  /// This is a request sent by the the client.
  final Request request;

  /// This is a request handler that processes accompanied request.
  final RequestHandler requestHandler;

  RequestMatcher(this.request, this.requestHandler);
}

/// HTTP method list.
enum RequestMethod {
  /// The [GET] method requests a representation of the specified resource.
  /// Requests using [GET] should only retrieve data.
  GET,

  /// The [HEAD] method asks for a response identical to that of a [GET] request,
  /// but without the response body.
  HEAD,

  /// The [POST] method is used to submit an entity to the specified resource,
  /// often causing a change in state or side effects on the server.
  POST,

  /// The [PUT] method replaces all current representations of the
  /// target resource with the request payload.
  PUT,

  /// The [DELETE] method deletes the specified resource.
  DELETE,

  /// The CONNECT method establishes a tunnel to the server
  /// identified by the target resource.
  CONNECT,

  /// The OPTIONS method is used to describe the communication options
  /// for the target resource.
  OPTIONS,

  /// The TRACE method performs a message loop-back test
  /// along the path to the target resource.
  TRACE,

  /// The PATCH method is used to apply partial modifications to a resource.
  PATCH,
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
