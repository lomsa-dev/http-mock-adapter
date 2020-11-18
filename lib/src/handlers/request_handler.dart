import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/adapter_interface.dart';
import 'package:http_mock_adapter/src/interceptors/http_interceptor.dart';

/// The handler of requests sent by clients.
class RequestHandler<T> {
  /// An HTTP status code such as - `200`, `404`, `500`, etc.
  int statusCode;
  RequestHandler() {
    /// If type parameter of the class is neither [DioAdapter] nor [DioInterceptor]
    /// throws [RequestHandlerException]
    if (T.runtimeType != DioAdapter || T.runtimeType != DioInterceptor) {
      RequestHandlerException();
    }
  }

  /// Map of <[int] statusCode, [dynamic] data>.
  final Map<int, dynamic> requestMap = {};

  /// Stores response.data in [requestMap] and returns [DioAdapter]
  /// the latter which is utilized for method chaining.
  AdapterInterface reply(int statusCode, dynamic data) {
    this.statusCode = statusCode;

    requestMap[this.statusCode] = data;

    // Checking the type of the `type parameter`
    // and returning the relevant Class Instance
    switch (T) {
      case DioInterceptor:
        return DioInterceptor();
        break;
      case DioAdapter:
        return DioAdapter();
        break;
      default:
        return DioAdapter();
        break;
    }
  }
}
