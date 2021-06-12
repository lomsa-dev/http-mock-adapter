import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/types.dart';

/// [RequestHandling] exposes developer-friendly methods which take in route,
/// [Request], both of which ultimately get processed by [RequestHandler].
mixin RequestHandling {
  void onRoute(
    Pattern route,
    RequestHandlerCallback requestHandlerCallback, {
    required Request request,
  });

  /// Takes in a route, requests with [RequestMethods.get],
  /// and sets corresponding [RequestHandler].
  void onGet(
    Pattern route,
    RequestHandlerCallback requestHandlerCallback, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      onRoute(
        route,
        requestHandlerCallback,
        request: Request(
          route: route,
          method: RequestMethods.get,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  /// Takes in a route, requests with [RequestMethods.head],
  /// and sets corresponding [RequestHandler].
  void onHead(
    Pattern route,
    RequestHandlerCallback requestHandlerCallback, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      onRoute(
        route,
        requestHandlerCallback,
        request: Request(
          route: route,
          method: RequestMethods.head,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  /// Takes in a route, requests with [RequestMethods.post],
  /// and sets corresponding [RequestHandler].
  void onPost(
    Pattern route,
    RequestHandlerCallback requestHandlerCallback, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      onRoute(
        route,
        requestHandlerCallback,
        request: Request(
          route: route,
          method: RequestMethods.post,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  /// Takes in a route, requests with [RequestMethods.put],
  /// and sets corresponding [RequestHandler].
  void onPut(
    Pattern route,
    RequestHandlerCallback requestHandlerCallback, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      onRoute(
        route,
        requestHandlerCallback,
        request: Request(
          route: route,
          method: RequestMethods.put,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  /// Takes in a route, requests with [RequestMethods.delete],
  /// and sets corresponding [RequestHandler].
  void onDelete(
    Pattern route,
    RequestHandlerCallback requestHandlerCallback, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      onRoute(
        route,
        requestHandlerCallback,
        request: Request(
          route: route,
          method: RequestMethods.delete,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  /// Takes in a route, requests with [RequestMethods.patch],
  /// and sets corresponding [RequestHandler].
  void onPatch(
    Pattern route,
    RequestHandlerCallback requestHandlerCallback, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      onRoute(
        route,
        requestHandlerCallback,
        request: Request(
          route: route,
          method: RequestMethods.patch,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );

  bool isError(MockResponse mockResponse) => mockResponse is MockDioError;
}
