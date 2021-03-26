import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/adapters/dio_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/interceptors/dio_interceptor.dart';
import 'package:http_mock_adapter/src/interfaces.dart';
import 'package:http_mock_adapter/src/matchers/matcher.dart';
import 'package:http_mock_adapter/src/matchers/matchers.dart';
import 'package:http_mock_adapter/src/types.dart';

/// [Request] class contains members to hold network request information.
class Request {
  /// This is the route specified by the client- expected to be [String] or [RegExp].
  final dynamic route;

  /// An HTTP method such as [RequestMethods.get] or [RequestMethods.post].
  final RequestMethods method;

  /// The payload.
  final dynamic data;

  /// Query parameters to encompass additional parameters to the query.
  final Map<String, dynamic> queryParameters;

  /// Headers to encompass content-types.
  final Map<String, dynamic>? headers;

  const Request({
    this.route,
    this.method = RequestMethods.get,
    this.data,
    queryParameters,
    headers,
  })  : queryParameters = queryParameters ?? const {},
        headers = headers ??
            const {
              Headers.contentTypeHeader: Headers.jsonContentType,
              Headers.contentLengthHeader: Matchers.integer,
            };

  /// [signature] is the [String] representation of the [Request]'s body.
  String get signature =>
      '$route/${method.value}/' +
      sortedData(data) +
      '/' +
      sortedData(queryParameters) +
      '/$headers';
}

/// [Signature] extension method adds [signature] getter to [RequestOptions]
/// in order to easily retrieve [Request]'s body representation as [String].
extension Signature on RequestOptions {
  /// [signature] is the [String] representation of the [RequestOptions]'s body.
  String get signature =>
      '$path/$method/' +
      sortedData(data) +
      '/' +
      sortedData(queryParameters) +
      '/$headers';
}

/// [sortedData] sorts request [Signature]'s and [Request.signature]'s 'data'
/// and 'queryParameters' portion if it is a subtype of [Map].
/// This makes sure, that data passed during request and data saved inside
/// 'requestMap' while using [RequestRouted.onPost] or other [RequestRouted]
/// methods will be exactly same inside the [Signature] which is used to
/// compare executed request to the list of requests saved by [DioAdapter] or
/// by [DioInterceptor].
String sortedData(dynamic data) {
  if (data is Map) {
    final dynamic sortedKeys = data.keys.toList()..sort();

    data = {for (final sortedKey in sortedKeys) sortedKey: data[sortedKey]};
  }

  return data.toString();
}

/// [MatchesRequest] enhances the [RequestOptions] by allowing different types
/// of matchers to validate the data and headers of the request.
extension MatchesRequest on RequestOptions {
  /// Check values against matchers.
  /// [request] is the configured [Request] which would contain the matchers if used.
  bool matchesRequest(Request request) {
    final routeMatched = doesRouteMatch(path, request.route);
    final requestBodyMatched = matches(data, request.data);

    final queryParametersMatched =
        matches(queryParameters, request.queryParameters);

    // dio adds headers to the request when none aare specified
    final requestHeaders = request.headers ??
        {
          Headers.contentTypeHeader: Headers.jsonContentType,
          Headers.contentLengthHeader: Matchers.number
        };
    final headersMatched = matches(headers, requestHeaders);

    if (!routeMatched ||
        method != request.method.value ||
        !requestBodyMatched ||
        !queryParametersMatched ||
        !headersMatched) {
      return false;
    }

    return true;
  }

  /// Check to see if route matches the mock specification
  /// Allows user to specify route as they intend rather than assuming string
  /// is a pattern. Route will be dynamic.
  bool doesRouteMatch(dynamic actual, dynamic expected) {
    // if null then fail. the route should never be null...ever.
    if (actual == null || expected == null) {
      return false;
    }

    // if strings, just compare
    if (actual is String && expected is String) {
      return actual == expected;
    }

    // allow regex match of route, expected should be provided via the mocking
    if (expected is RegExp) {
      return expected.hasMatch(actual);
    }

    // default to no match
    return false;
  }

  /// Check the map keys and values determined by the definition.
  bool matches(dynamic actual, dynamic expected) {
    if (actual == null && expected == null) {
      return true;
    }

    if (expected is Matcher) {
      /// Check the match here to bypass the fallthrough strict equality check
      /// at the end.
      if (!expected.matches(actual)) {
        return false;
      }
    } else if (actual is Map && expected is Map) {
      for (final key in actual.keys.toList()) {
        if (!expected.containsKey(key)) {
          return false;
        } else if (expected[key] is Matcher) {
          // Check matcher for the configured request.
          if (!expected[key].matches(actual[key])) {
            return false;
          }
        } else if (expected[key] != actual[key]) {
          // Exact match unless map.
          if (expected[key] is Map && actual[key] is Map) {
            if (!matches(actual[key], expected[key])) {
              // Allow maps to use matchers.
              return false;
            }
          } else if (expected[key].toString() != actual[key].toString()) {
            // If some other kind of object like list then rely on `toString`
            // to provide comparison value.
            return false;
          }
        }
      }
    } else if (actual is List && expected is List) {
      for (var index in Iterable.generate(actual.length)) {
        if (!matches(actual[index], expected[index])) {
          return false;
        }
      }
    } else if (actual is Set && expected is Set) {
      return !matches(actual.containsAll(expected), false);
    } else if (actual != expected) {
      // Fall back to original check.
      return false;
    }

    return true;
  }
}

/// Matcher of [Request] and [responseBody] based on route and [RequestHandler].
class RequestMatcher {
  /// This is a request sent by the the client.
  final Request request;

  /// This is a request handler that processes requests.
  final RequestHandler requestHandler;

  /// This is an artificial response body to the request.
  Responsable Function()? responseBody;

  RequestMatcher(
    this.request,
    this.requestHandler, {
    this.responseBody,
  });
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

/// [ValueToString] extension method grants [RequestMethods] enumeration
/// the ability to obtain [String] type depictions of enumeration's values.
extension ValueToString on RequestMethods {
  /// Gets the [String] depiction of the current value.
  String get value => toString().split('.').last.toUpperCase();
}

/// [RequestRouted] exposes developer-friendly methods which take in route,
/// [Request], both of which ultimately get processed by [RequestHandler].
mixin RequestRouted implements AdapterInterface {
  /// Takes in a route, requests with [RequestMethods.get],
  /// and sets corresponding [RequestHandler].
  @override
  void onGet(
    dynamic route,
    RequestHandlerCallback callback, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    dynamic headers,
  }) =>
      onRoute(
        route,
        callback,
        request: Request(
          method: RequestMethods.get,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  /// Takes in a route, requests with [RequestMethods.head],
  /// and sets corresponding [RequestHandler].
  @override
  void onHead(
    dynamic route,
    RequestHandlerCallback callback, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    dynamic headers,
  }) =>
      onRoute(
        route,
        callback,
        request: Request(
          method: RequestMethods.head,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  /// Takes in a route, requests with [RequestMethods.post],
  /// and sets corresponding [RequestHandler].
  @override
  void onPost(
    dynamic route,
    RequestHandlerCallback callback, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    dynamic headers,
  }) =>
      onRoute(
        route,
        callback,
        request: Request(
          method: RequestMethods.post,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  /// Takes in a route, requests with [RequestMethods.put],
  /// and sets corresponding [RequestHandler].
  @override
  void onPut(
    dynamic route,
    RequestHandlerCallback callback, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    dynamic headers,
  }) =>
      onRoute(
        route,
        callback,
        request: Request(
          method: RequestMethods.put,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  /// Takes in a route, requests with [RequestMethods.delete],
  /// and sets corresponding [RequestHandler].
  @override
  void onDelete(
    dynamic route,
    RequestHandlerCallback callback, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    dynamic headers,
  }) =>
      onRoute(
        route,
        callback,
        request: Request(
          method: RequestMethods.delete,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  /// Takes in a route, requests with [RequestMethods.patch],
  /// and sets corresponding [RequestHandler].
  @override
  void onPatch(
    dynamic route,
    RequestHandlerCallback callback, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    dynamic headers,
  }) =>
      onRoute(
        route,
        callback,
        request: Request(
          method: RequestMethods.patch,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  @override
  bool isError(Responsable response) => response is AdapterError;
}
