import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'request.dart';

/// Intended to keep track of request history.
class History {
  /// The index of request invocations.
  int _requestInvocationIndex;

  RequestMatcher requestMatcher;

  /// The history content containing [RequestMatcher] objects.
  List<RequestMatcher> data = [];

  /// Gets current [RequestMatcher].
  RequestMatcher get current => data[_requestInvocationIndex];

  /// Getter for the current request invocation's intended [responseBody].
  AdapterResponse Function(RequestOptions options) get responseBody =>
      (options) {
        if (options.headers == null || options.headers.isEmpty) {
          options.headers = {
            Headers.contentTypeHeader: Headers.jsonContentType,
          };
        }

        data.forEach((element) {
          if (options.signature == element.request.signature) {
            _requestInvocationIndex = data.indexOf(element);

            current.responseBody =
                requestHandler.requestMap[requestHandler.statusCode];
            // print(element.requestHandler.requestMap[requestHandler.statusCode]
            //     .runtimeType);
          }
        });

        final responseBody = current.responseBody;

        return responseBody;
      };

  /// Getter for the current request invocation's [RequestHandler].
  RequestHandler get requestHandler => current.requestHandler;
}

/// An ability that lets a construct to have a [History] instance.
mixin Tracked {
  final history = History();
}
