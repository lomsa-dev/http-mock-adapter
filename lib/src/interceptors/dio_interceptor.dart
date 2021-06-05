import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/history.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/types.dart';

/// [DioInterceptor] is a class for mocking the [Dio] requests with interceptors.
///
/// This means you can mock any request of [Dio] by adding the
/// instance of [DioInterceptor] inside the original [Dio]'s interceptors' list.
///
/// Usage:
/// ```dart
/// // Create Dio instance
/// Dio dio = Dio()
/// // Create instance of our([DioInterceptor]) Interceptor
/// DioInterceptor interceptor = DioInterceptor()
/// // Adding routes and their mocked responses as chains
/// interceptor
/// .onGet("/route-1")
/// .reply("response for route 1")
/// .onPost("/route-2")
/// .reply("response for route 2")
/// .onPatch("/route-3")
/// .reply("response for route 3")
/// // adding interceptor inside the [Dio]'s interceptors
/// dio.interceptors.add(interceptor);
/// ```
/// If you now make request like this `dio.get("/route-1");`
/// Your response will be `Response(data:"response for route 1",........)`
class DioInterceptor extends Interceptor with Tracked, RequestRouted {
  /// Takes in route, request, sets corresponding [RequestHandler],
  /// adds an instance of [RequestMatcher] in [History.data].
  @override
  Future<void> onRoute(
    dynamic route,
    RequestHandlerCallback callback, {
    Request request = const Request(),
    Duration delay = Duration.zero,
  }) async {
    await Future.delayed(delay);
    final handler = RequestHandler<DioInterceptor>();
    callback(handler);
    history.data.add(
      RequestMatcher(
        Request(
          route: route,
          method: request.method,
          data: request.data,
          queryParameters: request.queryParameters,
          headers: request.headers,
        ),
        handler,
      ),
    );
  }

  /// Dio [Interceptor]`s [onRequest] configuration intended to catch and return
  /// mocked request and data respectively.
  @override
  void onRequest(options, handler) async {
    final response = history.responseBody(options);

    // Reject the response if type is AdapterError.
    if (isError(response)) {
      handler.reject(response as DioError);
      return;
    }

    final responseBody = response as AdapterResponse;

    handler.resolve(Response(
      data: await DefaultTransformer().transformResponse(options, responseBody),
      headers: Headers.fromMap(responseBody.headers),
      isRedirect: responseBody.isRedirect,
      redirects: responseBody.redirects ?? [],
      requestOptions: options,
      statusCode: responseBody.statusCode,
      statusMessage: responseBody.statusMessage,
    ));
  }
}

