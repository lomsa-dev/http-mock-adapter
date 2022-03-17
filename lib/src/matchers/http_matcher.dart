import 'package:dio/dio.dart';

import '../../http_mock_adapter.dart';

/// This class serves as an abstraction for matching http requests.
/// Consumers can provide customized matchers as per their use case.
/// An instance of this is supplied while creating the [DioAdapter] or
/// [DioInterceptor].
///
/// Sample usage:
/// ```dart
/// final adapter = DioAdapter(dio: dio, matcher: UrlRequestMatcher());
/// ```
///
/// Note: The default matcher is [FullHttpRequestMatcher].
///
abstract class HttpRequestMatcher {
  const HttpRequestMatcher();

  bool matches(RequestOptions ongoingRequest, Request matcher);
}

/// [FullHttpRequestMatcher] is the default matcher and matches the entire URL
/// signature including headers, request body, query parameters etc. If no
/// matcher is specified in the adapter then it uses an instance of the this
/// class.
///
class FullHttpRequestMatcher extends HttpRequestMatcher {
  const FullHttpRequestMatcher();

  @override
  bool matches(RequestOptions ongoingRequest, Request matcher) {
    return ongoingRequest.matchesRequest(matcher);
  }
}

/// [UrlRequestMatcher] allows one to match the request based on the
/// path of the URL and optionally the HTTP Method (via [matchMethod]) rather
/// than the entire request signature.
///
class UrlRequestMatcher extends HttpRequestMatcher {
  final bool matchMethod;
  const UrlRequestMatcher({this.matchMethod = false});

  @override
  bool matches(RequestOptions ongoingRequest, Request matcher) {
    final isTheSameRoute =
        ongoingRequest.doesRouteMatch(ongoingRequest.path, matcher.route);
    return isTheSameRoute &&
        (!matchMethod || ongoingRequest.method == matcher.method?.name);
  }
}
