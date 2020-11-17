import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/history.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/adapter_interface.dart';

class MainInterceptor extends Interceptor
    with Tracked, RequestRouted
    implements AdapterInterface {
  /// [MainInterceptor]'s singleton instance
  static MainInterceptor _interceptor = MainInterceptor._construct();

  /// [MainInterceptor]'s private constructor method
  MainInterceptor._construct();

  /// Factory method of [MainInterceptor] utilized to return [_interceptor]
  /// singleton instance each time it is called;
  factory MainInterceptor() {
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
    final requestHandler = RequestHandler<MainInterceptor>();
    history.data.add(RequestMatcher(route, request, requestHandler));

    return requestHandler;
  }
}

// void main(List<String> args) async {
//   MainInterceptor inercept = MainInterceptor();
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
