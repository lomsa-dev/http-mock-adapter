import 'package:dio/dio.dart';

import '../../http_mock_adapter.dart';

abstract class HttpRequestMatcher {
  const HttpRequestMatcher();

  bool matches(RequestOptions ongoingRequest, Request matcher);
}

class FullHttpRequestMatcher extends HttpRequestMatcher {
  const FullHttpRequestMatcher();

  @override
  bool matches(RequestOptions ongoingRequest, Request matcher) {
    return ongoingRequest.matchesRequest(matcher);
  }
}

class UrlRequestMatcher extends HttpRequestMatcher {
  final bool matchMethod;

  UrlRequestMatcher({this.matchMethod = false});

  @override
  bool matches(RequestOptions ongoingRequest, Request matcher) {
    final isRouteTheSame =
        ongoingRequest.doesRouteMatch(ongoingRequest.path, matcher.route);
    return isRouteTheSame &&
        (!matchMethod || ongoingRequest.method == matcher.method?.name);
  }
}
