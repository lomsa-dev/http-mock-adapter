import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/adapters/dio_adapter.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/interceptors/dio_interceptor.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:meta/meta.dart';

/// Top level interface of all the adapters.
/// It is implemented by [DioInterceptor] and [DioAdapter].
///
/// This Interface is used for 2 reasons:
/// 1. To maintain the nice and best practice oriented way of architecture;
/// 2. Because of the reason that [RequestHandler] is returning different
/// class instances form reply method, depending on its generic type
/// parameters by using [dynamic] type for reply was removing
/// autocompletion ability, and that's why both Adapters
/// implement this interface to provide good developer experience.
abstract class AdapterInterface {
  void onGet(
    dynamic route, {
    dynamic data,
    dynamic headers,
    @required void Function(RequestHandler response) handler,
  });
  RequestHandler onRoute(dynamic route, {Request request = const Request()});
  void onHead(
    dynamic route, {
    dynamic data,
    dynamic headers,
    @required void Function(RequestHandler response) handler,
  });
  void onPost(
    dynamic route, {
    dynamic data,
    dynamic headers,
    @required void Function(RequestHandler response) handler,
  });
  void onPut(
    dynamic route, {
    dynamic data,
    dynamic headers,
    @required void Function(RequestHandler response) handler,
  });
  void onDelete(
    dynamic route, {
    dynamic data,
    dynamic headers,
    @required void Function(RequestHandler response) handler,
  });
  void onPatch(
    dynamic route, {
    dynamic data,
    dynamic headers,
    @required void Function(RequestHandler response) handler,
  });
  void throwError(Responsable response);
}

/// Top level interface for [Dio]'s [ResponseBody] and also [Dio]'s [DioError].
/// This interface makes sure that we can save [DioError] and [ResponseBody]
/// inside the same list.
abstract class Responsable {}
