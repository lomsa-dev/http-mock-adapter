import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/history.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/adapter_interface.dart';

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
/// // adding intercetor inside the [Dio]'s interceptors
/// dio.interceptors.add(interceptor);
/// ```
/// If you now make request like this `dio.get("/route-1");`
/// Your response will be `Response(data:"response for route 1",........)`

class DioInterceptor extends Interceptor
    with Tracked, RequestRouted
    implements AdapterInterface {
  /// [MainInterceptor]'s singleton instance
  static DioInterceptor _interceptor = DioInterceptor._construct();

  /// [MainInterceptor]'s private constructor method
  DioInterceptor._construct();

  /// Factory method of [MainInterceptor] utilized to return [_interceptor]
  /// singleton instance each time it is called;
  factory DioInterceptor() {
    return _interceptor;
  }

  /// Dio [Interceptor]`s [onRequest] configuration intended to catch and return
  /// mocked request and data respectively
  @override
  Future<Response> onRequest(req) async {
    return Response(data: history.response, statusCode: HttpStatus.ok);
  }

  /// Takes in route, request, sets corresponding [RequestHandler],
  /// adds an instance of [RequestMatcher] in [History.data].
  @override
  RequestHandler onRoute(String route, {Request request = const Request()}) {
    final requestHandler = RequestHandler<DioInterceptor>();
    history.data.add(RequestMatcher(route, request, requestHandler));

    return requestHandler;
  }
}

// void main(List<String> args) async {
//   DioInterceptor inercept = DioInterceptor();
//   Dio dio = Dio();

//   inercept
//       .onGet("https://example.com")
//       .reply(200, 'PLS')
//       .onGet("https://example.com/ok")
//       .reply(200, 'dis');

//   dio.interceptors.add(inercept);
//   Response resp = await dio.get("https://example.com");
//   Response resp2 = await dio.get("https://example.com/ok");
//   print(resp);
//   print(resp2);
// }
