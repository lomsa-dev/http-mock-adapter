import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/constants.dart' as constants;
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/mixins/mixins.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/types.dart';

/// [DioInterceptor] is a class for mocking [Dio] requests with [Interceptor].
class DioInterceptor extends Interceptor with Recording, RequestHandling {
  /// An HTTP method such as [RequestMethods.get] or [RequestMethods.post].
  RequestMethods method;

  /// The payload.
  dynamic data;

  /// Query parameters to encompass additional parameters to the query.
  Map<String, dynamic> queryParameters;

  /// Headers to encompass content-types.
  Map<String, dynamic> headers;

  DioInterceptor({
    this.method = constants.defaultRequestMethod,
    this.data,
    this.queryParameters = constants.defaultQueryParameters,
    this.headers = constants.defaultHeaders,
  });

  /// Takes in route, request, sets corresponding [RequestHandler],
  /// adds an instance of [RequestMatcher] in [history].
  @override
  void onRoute(
    Pattern route,
    MockServerCallback requestHandlerCallback, {
    required Request request,
  }) {
    request = Request(
      route: route,
      method: request.method ?? method,
      data: request.data ?? data,
      queryParameters: request.queryParameters ?? queryParameters,
      headers: request.headers ?? headers,
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
