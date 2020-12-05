import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/request.dart';

/// Top level interface of all the adapters.
/// It is implemented by DioInterceptor and DioAdapter.
///
/// This Interface is use for 2 reqsons:
/// 1. To maintain the nice and best practice orinted way of architecture
/// 2.  Because of the reason that [RequestHandler] is returning different
/// class instances form reply method, depending on its generic type
/// parameters by using [dynamic] type for reply was removing
/// autocomplition ability that's why both Adapters implement this interface
/// to provide good developer experience.
typedef AdapterRequest = RequestHandler Function(
  String route, {
  dynamic data,
  dynamic headers,
});

abstract class AdapterInterface {
  AdapterRequest get onGet;
  RequestHandler onRoute(String route, {Request request = const Request()});
  AdapterRequest get onHead;
  AdapterRequest get onPost;
  AdapterRequest get onPut;
  AdapterRequest get onDelete;
  AdapterRequest get onPatch;
}

abstract class Responsable {}
