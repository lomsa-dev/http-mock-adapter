import 'package:http_mock_adapter/src/extensions/extensions.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/utils.dart';

/// [Request] class contains members to hold network request information.
class Request {
  /// This is the route specified by the client- expected to be [String] or [RegExp].
  final Pattern? route;

  /// An HTTP method such as [RequestMethods.get] or [RequestMethods.post].
  final RequestMethods? method;

  /// The payload.
  final dynamic data;

  /// Query parameters to encompass additional parameters to the query.
  final Map<String, dynamic>? queryParameters;

  /// Headers to encompass content-types.
  final Map<String, dynamic>? headers;

  const Request({
    this.route,
    this.method,
    this.data,
    this.queryParameters,
    this.headers,
  });

  /// [signature] is the [String] representation of the [Request]'s body.
  String get signature => buildRequestSignature(
        method?.toUpperCaseString,
        route,
        data,
        queryParameters,
        headers,
      );
}

/// Matches a [Request] to a [MockResponse].
class RequestMatcher extends RequestHandler {
  /// This is a request sent by the the client.
  final Request request;

  RequestMatcher(this.request);
}

/// HTTP methods.
enum RequestMethods {
  /// The [get] method requests a representation of the specified resource.
  /// Requests using [get] should only retrieve data.
  get,

  /// The [head] method asks for a response identical to that of a [get] request,
  /// but without the response body.
  head,

  /// The [post] method is used to submit an entity to the specified resource,
  /// often causing a change in state or side effects on the server.
  post,

  /// The [put] method replaces all current representations of the
  /// target resource with the request payload.
  put,

  /// The [delete] method deletes the specified resource.
  delete,

  /// The [patch] method is used to apply partial modifications to a resource.
  patch,
}
