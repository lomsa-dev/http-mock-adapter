import 'package:http_mock_adapter/src/extensions/signature.dart';
import 'package:http_mock_adapter/src/matchers/http_matcher.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/types.dart';

/// An ability that lets a construct to record a [RequestMatcher] history.
mixin Recording {
  HttpRequestMatcher get matcher;

  /// The index of request invocations.
  int? _invocationIndex;

  /// The history content containing [RequestMatcher] objects.
  final List<RequestMatcher> _requestMatchers = [];

  /// Gets current [RequestMatcher].
  RequestMatcher get requestMatcher => _requestMatchers[_invocationIndex!];

  /// Getter for the current request invocation's intended [mockResponse].
  MockResponseBodyCallback get mockResponse => (requestOptions) {
        _invocationIndex = null;

        for (var requestMatcher in _requestMatchers) {
          if (requestOptions.signature == requestMatcher.request.signature ||
              matcher.matches(requestOptions, requestMatcher.request)) {
            _invocationIndex = _requestMatchers.indexOf(requestMatcher);
          }
        }

        // Fail when a mocked route is not found for the request.
        if (_invocationIndex == null || _invocationIndex! < 0) {
          throw AssertionError(
            'Could not find mocked route matching request for ${requestOptions.signature}',
          );
        }

        return requestMatcher.mockResponse(requestOptions);
      };

  /// Keeps track of request and response history.
  List<RequestMatcher> get history => _requestMatchers;

  /// Resets the [history].
  void reset() => history.clear();
}
