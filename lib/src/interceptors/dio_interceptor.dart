import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/mixins/mixins.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/types.dart';

/// [DioInterceptor] is a class for mocking [Dio] requests with [Interceptor].
class DioInterceptor extends Interceptor with Recording, RequestHandling {
  /// These should be the same [BaseOptions] that are configured for [Dio].
  final BaseOptions baseOptions;

  DioInterceptor({
    required this.baseOptions,
  });

  /// Simple helper function to create an adapter
  /// and configure it correctly with an existing [Dio] instance.
  factory DioInterceptor.configure({required Dio dio}) {
    final interceptor = DioInterceptor(baseOptions: dio.options);
    dio.interceptors.add(interceptor);
    return interceptor;
  }

  /// Takes in route, request, sets corresponding [RequestHandler],
  /// adds an instance of [RequestMatcher] in [history].
  @override
  void onRoute(
    Pattern route,
    MockServerCallback requestHandlerCallback, {
    required Request request,
  }) {
    final requestData = request.data;
    final requestMethod =
        request.method ?? RequestMethods.forName(name: baseOptions.method);

    Map<String, dynamic> requestHeaders = {...request.headers ?? {}};

    if (requestMethod.isAllowedPayloadMethod ||
        baseOptions.setRequestContentTypeWhenNoPayload) {
      requestHeaders.putIfAbsent(
        Headers.contentTypeHeader,
        () => Headers.jsonContentType,
      );
    }

    if (requestMethod.isAllowedPayloadMethod && requestData != null) {
      requestHeaders.putIfAbsent(
        Headers.contentLengthHeader,
        () => Matchers.integer,
      );
    }

    request = Request(
      route: route,
      method: requestMethod,
      data: requestData,
      queryParameters: request.queryParameters ?? baseOptions.queryParameters,
      headers: requestHeaders,
    );

    final matcher = RequestMatcher(request);
    requestHandlerCallback(matcher);
    history.add(matcher);
  }

  /// Dio [Interceptor]`s [onRequest] configuration intended to catch and return
  /// mocked request and data respectively.
  @override
  void onRequest(requestOptions, requestInterceptorHandler) async {
    final response = mockResponse(requestOptions);

    // Reject the response if type is MockDioError.
    if (isMockDioError(response)) {
      requestInterceptorHandler.reject(response as DioError);

      return;
    }

    final responseBody = response as MockResponseBody;

    requestInterceptorHandler.resolve(
      Response(
        data: await DefaultTransformer().transformResponse(
          requestOptions,
          responseBody,
        ),
        headers: Headers.fromMap(responseBody.headers),
        isRedirect: responseBody.isRedirect,
        redirects: responseBody.redirects ?? [],
        requestOptions: requestOptions,
        statusCode: responseBody.statusCode,
        statusMessage: responseBody.statusMessage,
      ),
    );
  }
}
