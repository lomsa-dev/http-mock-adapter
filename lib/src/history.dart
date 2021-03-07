import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/types.dart';

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
  AdapterResponseBody get responseBody => (options) {
        data.forEach((element) {
          if (options.signature == element.request.signature ||
              options.matchesRequest(element.request)) {
            _requestInvocationIndex = data.indexOf(element);

            current.responseBody =
                requestHandler.requestMap[requestHandler.statusCode];
          }
        });

        // Fail when a mocked route is not found for the request.
        if (_requestInvocationIndex == null || _requestInvocationIndex < 0) {
          throw AssertionError(
            'Could not find mocked route matching request for ${options.signature}',
          );
        }

        return current.responseBody();
      };

  /// Getter for the current request invocation's [RequestHandler].
  RequestHandler get requestHandler => current.requestHandler;

  /// Clears the [data] list.
  void reset() => data.clear();
}

/// An ability that lets a construct to have a [History] instance.
mixin Tracked {
  final history = History();
}
