import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/mixins/mixins.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/types.dart';

/// [RequestHandling] exposes developer-friendly methods which take in route,
/// [Request], both of which ultimately get processed by [RequestHandler].
mixin RequestHandling on Recording {
  Dio get dio;

  /// Configures default headers which are usually set by [DioMixin].
  /// * content-type
  /// * content-length
  Future<void> setDefaultRequestHeaders(Dio dio, RequestOptions options) async {
    final data = options.data;
    if (data != null &&
        RequestMethods.allowedPayloadMethods
            .contains(RequestMethods.forName(name: options.method))) {
      if (data is FormData) {
        options.headers[Headers.contentTypeHeader] =
            'multipart/form-data; boundary=${data.boundary}';
        options.headers[Headers.contentLengthHeader] = data.length.toString();
      } else {
        final _data = await dio.transformer.transformRequest(options);
        List<int> bytes;
        if (options.requestEncoder != null) {
          bytes = options.requestEncoder!(_data, options);
        } else {
          bytes = utf8.encode(_data);
        }
        options.headers[Headers.contentLengthHeader] = bytes.length.toString();
      }
    }
  }

  /// Takes in [route], [request], sets corresponding [RequestHandler],
  /// adds an instance of [RequestMatcher] in [history].
  void onRoute(
    Pattern route,
    MockServerCallback requestHandlerCallback, {
    required Request request,
  }) {
    var requestData = request.data;

    // Automatically add form data matcher if it is not provided
    if (requestData is FormData) {
      requestData = Matchers.formData(requestData);
    }

    final matcher = RequestMatcher(Request(
      route: route,
      method:
          request.method ?? RequestMethods.forName(name: dio.options.method),
      data: requestData,
      queryParameters: request.queryParameters ?? dio.options.queryParameters,
      headers: {...?request.headers},
    ));

    requestHandlerCallback(matcher);
    history.add(matcher);
  }

  /// Takes in a route, requests with [RequestMethods.get],
  /// and sets corresponding [RequestHandler].
  void onGet(
    Pattern route,
    MockServerCallback requestHandlerCallback, {
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
    MockServerCallback requestHandlerCallback, {
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
    MockServerCallback requestHandlerCallback, {
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
    MockServerCallback requestHandlerCallback, {
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
    MockServerCallback requestHandlerCallback, {
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
    MockServerCallback requestHandlerCallback, {
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

  bool isMockDioError(MockResponse mockResponse) =>
      mockResponse is MockDioError;
}
