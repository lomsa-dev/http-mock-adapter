import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/request.dart';

/// Top level interface of all the adapters.
/// It is implemented by [MainInterceptor] and [DioAdapter].
///
/// This Interface is use for 2 reqsons:
/// 1. To maintain the nice and best practice orinted way of architecture
/// 2.  Because of the reason that [RequestHandler] is returning different
/// class instances form [reply] method, depending on its generic type
/// parameters by using [dynamic] type for [reply] was removing
/// autocomplition ability, that's why both Adapters implement this interface
/// to provide good developer experience.

abstract class AdapterInterface {
  RequestHandler onGet(String route, {dynamic data, dynamic headers});
  RequestHandler onRoute(String route, {Request request = const Request()});
  RequestHandler onHead(String route, {dynamic data, dynamic headers});
  RequestHandler onPost(String route, {dynamic data, dynamic headers});
  RequestHandler onPut(String route, {dynamic data, dynamic headers});
  RequestHandler onDelete(String route, {dynamic data, dynamic headers});
  RequestHandler onConnect(String route, {dynamic data, dynamic headers});
  RequestHandler onOptions(String route, {dynamic data, dynamic headers});
  RequestHandler onTrace(String route, {dynamic data, dynamic headers});
  RequestHandler onPatch(String route, {dynamic data, dynamic headers});
}
