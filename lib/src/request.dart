import 'package:meta/meta.dart';

import 'handlers/request_handler.dart';

/// [Request] class contains members to hold network request information.
class Request {
  /// An HTTP method such as [RequestMethods.GET] or [RequestMethods.POST].
  final RequestMethods method;

  /// The payload.
  final dynamic data;

  /// Headers to encompass content-types.
  final dynamic headers;

  const Request({this.method = RequestMethods.GET, this.data, this.headers});
}

/// Matcher of [Request] and [response] based on [route] and [RequestHandler].
class RequestMatcher {
  /// This is the route specified by the client.
  final String route;

  /// This is a request sent by the the client.
  final Request request;

  /// This is a request handler that processes requests.
  final RequestHandler requestHandler;

  /// This is an artificial response to the request.
  dynamic response;

  RequestMatcher(
    this.route,
    this.request,
    this.requestHandler, {
    this.response,
  });
}

/// HTTP methods.
enum RequestMethods {
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

  /// The [CONNECT] method establishes a tunnel to the server
  /// identified by the target resource.
  CONNECT,

  /// The [OPTIONS] method is used to describe the communication options
  /// for the target resource.
  OPTIONS,

  /// The [TRACE] method performs a message loop-back test
  /// along the path to the target resource.
  TRACE,

  /// The [PATCH] method is used to apply partial modifications to a resource.
  PATCH,
}

/// [RequestRouted] exposes developer-friendly methods which take in route,
/// [Request], both of which ultimately get processed by [RequestHandler].
mixin RequestRouted {
  /// Takes in route, request, and sets corresponding [RequestHandler].
  @visibleForOverriding
  RequestHandler onRoute(String route, {Request request = const Request()});

  /// Takes in a route, requests with [RequestMethods.GET],
  /// and sets corresponding [RequestHandler].
  RequestHandler onGet(String route, {dynamic data, dynamic headers}) {
    return onRoute(
      route,
      request: Request(
        method: RequestMethods.GET,
        data: data,
        headers: headers,
      ),
    );
  }

  /// Takes in a route, requests with [RequestMethods.HEAD],
  /// and sets corresponding [RequestHandler].
  RequestHandler onHead(String route, {dynamic data, dynamic headers}) {
    return onRoute(
      route,
      request: Request(
        method: RequestMethods.HEAD,
        data: data,
        headers: headers,
      ),
    );
  }

  /// Takes in a route, requests with [RequestMethods.POST],
  /// and sets corresponding [RequestHandler].
  RequestHandler onPost(String route, {dynamic data, dynamic headers}) {
    return onRoute(
      route,
      request: Request(
        method: RequestMethods.POST,
        data: data,
        headers: headers,
      ),
    );
  }

  /// Takes in a route, requests with [RequestMethods.PUT],
  /// and sets corresponding [RequestHandler].
  RequestHandler onPut(String route, {dynamic data, dynamic headers}) {
    return onRoute(
      route,
      request: Request(
        method: RequestMethods.PUT,
        data: data,
        headers: headers,
      ),
    );
  }

  /// Takes in a route, requests with [RequestMethods.DELETE],
  /// and sets corresponding [RequestHandler].
  RequestHandler onDelete(String route, {dynamic data, dynamic headers}) {
    return onRoute(
      route,
      request: Request(
        method: RequestMethods.DELETE,
        data: data,
        headers: headers,
      ),
    );
  }

  /// Takes in a route, requests with [RequestMethods.CONNECT],
  /// and sets corresponding [RequestHandler].
  RequestHandler onConnect(String route, {dynamic data, dynamic headers}) {
    return onRoute(
      route,
      request: Request(
        method: RequestMethods.CONNECT,
        data: data,
        headers: headers,
      ),
    );
  }

  /// Takes in a route, requests with [RequestMethods.OPTIONS],
  /// and sets corresponding [RequestHandler].
  RequestHandler onOptions(String route, {dynamic data, dynamic headers}) {
    return onRoute(
      route,
      request: Request(
        method: RequestMethods.OPTIONS,
        data: data,
        headers: headers,
      ),
    );
  }

  /// Takes in a route, requests with [RequestMethods.TRACE],
  /// and sets corresponding [RequestHandler].
  RequestHandler onTrace(String route, {dynamic data, dynamic headers}) {
    return onRoute(
      route,
      request: Request(
        method: RequestMethods.TRACE,
        data: data,
        headers: headers,
      ),
    );
  }

  /// Takes in a route, requests with [RequestMethods.PATCH],
  /// and sets corresponding [RequestHandler].
  RequestHandler onPatch(String route, {dynamic data, dynamic headers}) {
    return onRoute(
      route,
      request: Request(
        method: RequestMethods.PATCH,
        data: data,
        headers: headers,
      ),
    );
  }
}
