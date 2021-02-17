import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/adapters/dio_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/interceptors/dio_interceptor.dart';
import 'package:http_mock_adapter/src/interfaces.dart';
import 'package:http_mock_adapter/src/matchers/matcher.dart';
import 'package:http_mock_adapter/src/matchers/matchers.dart';
import 'package:http_mock_adapter/src/types.dart';
import 'package:meta/meta.dart';

/// [Request] class contains members to hold network request information.
class Request {
  /// This is the route specified by the client.
  final String route;

  /// An HTTP method such as [RequestMethods.GET] or [RequestMethods.POST].
  final RequestMethods method;

  /// The payload.
  final dynamic data;

  /// Query parameters to encompass additional parameters to the query.
  final Map<String, dynamic> queryParameters;

  /// Headers to encompass content-types.
  final Map<String, dynamic> headers;

  const Request({
    this.route,
    this.method = RequestMethods.GET,
    this.data,
    this.queryParameters = const {},
    this.headers = const {
      Headers.contentTypeHeader: Headers.jsonContentType,
      Headers.contentLengthHeader: Matchers.integer,
    },
  });

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
/// methods will be excatly same inside the [Signature] which is used to
/// compare executed request to the list of requests saved by [DioAdapter] or
/// by [DioInterceptor].
String sortedData(dynamic data) {
  if (data is Map) {
    final sortedKeys = data.keys.toList()..sort();

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
    final requestBodyMatched = matches(data, request.data);

    final queryParametersMatched =
        matches(queryParameters, request.queryParameters);

    // dio adds headers to the requeset when none aare specified
    final requestHeaders = request.headers ??
        {
          Headers.contentTypeHeader: Headers.jsonContentType,
          Headers.contentLengthHeader: Matchers.number
        };
    final headersMatched = matches(headers, requestHeaders);

    if (path != request.route ||
        method != request.method.value ||
        !requestBodyMatched ||
        !queryParametersMatched ||
        !headersMatched) {
      return false;
    }

    return true;
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
  Responsable responseBody;

  RequestMatcher(
    this.request,
    this.requestHandler, {
    this.responseBody,
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

  /// The [PATCH] method is used to apply partial modifications to a resource.
  PATCH,
}

/// [ValueToString] extension method grants [RequestMethods] enumeration
/// the ability to obtain [String] type depictions of enumeration's values.
extension ValueToString on RequestMethods {
  /// Gets the [String] depiction of the current value.
  String get value => toString().split('.').last;
}

/// [RequestRouted] exposes developer-friendly methods which take in route,
/// [Request], both of which ultimately get processed by [RequestHandler].
mixin RequestRouted {
  /// Takes in route, request, and sets corresponding [RequestHandler].
  @visibleForOverriding
  RequestHandler onRoute(String route, {Request request = const Request()});

  /// Takes in a route, requests with [RequestMethods.GET],
  /// and sets corresponding [RequestHandler].
  AdapterRequest get onGet => (
        String route, {
        dynamic data,
        dynamic headers,
      }) =>
          onRoute(
            route,
            request: Request(
              method: RequestMethods.GET,
              data: data,
              headers: headers,
            ),
          );

  /// Takes in a route, requests with [RequestMethods.HEAD],
  /// and sets corresponding [RequestHandler].
  AdapterRequest get onHead => (
        String route, {
        dynamic data,
        dynamic headers,
      }) =>
          onRoute(
            route,
            request: Request(
              method: RequestMethods.HEAD,
              data: data,
              headers: headers,
            ),
          );

  /// Takes in a route, requests with [RequestMethods.POST],
  /// and sets corresponding [RequestHandler].
  AdapterRequest get onPost => (
        String route, {
        dynamic data,
        dynamic headers,
      }) =>
          onRoute(
            route,
            request: Request(
              method: RequestMethods.POST,
              data: data,
              headers: headers,
            ),
          );

  /// Takes in a route, requests with [RequestMethods.PUT],
  /// and sets corresponding [RequestHandler].
  AdapterRequest get onPut => (
        String route, {
        dynamic data,
        dynamic headers,
      }) =>
          onRoute(
            route,
            request: Request(
              method: RequestMethods.PUT,
              data: data,
              headers: headers,
            ),
          );

  /// Takes in a route, requests with [RequestMethods.DELETE],
  /// and sets corresponding [RequestHandler].
  AdapterRequest get onDelete => (
        String route, {
        dynamic data,
        dynamic headers,
      }) =>
          onRoute(
            route,
            request: Request(
              method: RequestMethods.DELETE,
              data: data,
              headers: headers,
            ),
          );

  /// Takes in a route, requests with [RequestMethods.PATCH],
  /// and sets corresponding [RequestHandler].
  AdapterRequest get onPatch => (
        String route, {
        dynamic data,
        dynamic headers,
      }) =>
          onRoute(
            route,
            request: Request(
              method: RequestMethods.PATCH,
              data: data,
              headers: headers,
            ),
          );

  dynamic throwError(Responsable response) {
    if (response.runtimeType == AdapterError) {
      AdapterError error = response;

      return throw error;
    }
  }
}
