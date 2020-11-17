import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/Exceptions.dart';
import 'package:http_mock_adapter/src/adapter_interface.dart';
import 'package:http_mock_adapter/src/interceptors/http_interceptor.dart';

/// The handler of requests sent by clients.
class RequestHandler<T> {
  /// An HTTP status code such as - `200`, `404`, `500`, etc.
  int statusCode;
  AdapterInterface _returnObject;
  RequestHandler() {
    /// If type parameter of the class is neither [DioAdapter] nor [MainInterceptor]
    /// throws [RequestHandlerException]
    if (T.runtimeType != DioAdapter || T.runtimeType != MainInterceptor)
      RequestHandlerException();
  }

  /// Map of <[statusCode], [data]>.
  final Map<int, dynamic> requestMap = {};

  /// Stores [response.data] in [requestMap] and returns [DioAdapter]
  /// the latter which is utilized for method chaining.
  AdapterInterface reply(int statusCode, dynamic data) {
    this.statusCode = statusCode;

    requestMap[this.statusCode] = data;

    // Checking the type of the `type parameter`
    // and returning the relevant Class Instance
    switch (T) {
      case MainInterceptor:
        _returnObject = MainInterceptor();
        break;
      case DioAdapter:
        _returnObject = DioAdapter();
        break;
      default:
        _returnObject = DioAdapter();
        break;
    }
    return _returnObject;
  }
}
