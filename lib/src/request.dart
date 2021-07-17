import 'package:dio/dio.dart';
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
        method?.name,
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
class RequestMethods {
  /// The [get] method requests a representation of the specified resource.
  /// Requests using [get] should only retrieve data.
  static const RequestMethods get = RequestMethods._('GET');

  /// The [head] method asks for a response identical to that of a [get] request,
  /// but without the response body.
  static const RequestMethods head = RequestMethods._('HEAD');

  /// The [post] method is used to submit an entity to the specified resource,
  /// often causing a change in state or side effects on the server.
  static const RequestMethods post = RequestMethods._('POST');

  /// The [put] method replaces all current representations of the
  /// target resource with the request payload.
  static const RequestMethods put = RequestMethods._('PUT');

  /// The [delete] method deletes the specified resource.
  static const RequestMethods delete = RequestMethods._('DELETE');

  /// The [patch] method is used to apply partial modifications to a resource.
  static const RequestMethods patch = RequestMethods._('PATCH');

  /// Taken from [BaseOptions]. The default methods that are considered
  /// to have a payload. Only for these methods a default content-type header is
  /// added, if no specified.
  static const allowedPayloadMethods = [post, put, patch, delete];

  static const _all = [get, head, post, put, patch, delete];

  final String name;

  bool get isAllowedPayloadMethod => allowedPayloadMethods.contains(this);

  factory RequestMethods.forName({required String name}) {
    return _all.firstWhere((m) => m.name == name);
  }

  const RequestMethods._(this.name);
}
