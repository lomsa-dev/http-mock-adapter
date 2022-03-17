import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  const String path = '/test';

  const fullHttpRequestMatcher = FullHttpRequestMatcher();
  const urlRequestMatcher = UrlRequestMatcher();

  group('FullHttpRequestMatcher', () {
    test('matches properly', () {
      // Base options which would be used to compare with tests[request].
      final options = RequestOptions(
        path: path,
        method: 'GET',
        contentType: Headers.jsonContentType,
        queryParameters: {},
      );

      // [Request] to [Expected] test map.
      // Request is the object that'd be compared with [options]
      // and the Expected boolean is result of that comparison.
      const tests = {
        Request(
          route: path,
          method: RequestMethods.get,
          queryParameters: <String, dynamic>{},
        ): true,
        Request(
          route: path,
          method: RequestMethods.post,
          queryParameters: <String, dynamic>{},
        ): false,
      };

      tests.forEach((request, expected) {
        expect(
          fullHttpRequestMatcher.matches(options, request),
          expected,
        );
      });
    });
  });

  group('UrlRequestMatcher', () {
    test('matches properly', () {
      // Base options which would be used to compare with tests[request].
      final options = RequestOptions(
        path: path,
        method: 'GET',
        contentType: Headers.jsonContentType,
        queryParameters: {},
      );

      // [Request] to [Expected] test map.
      // Request is the object that'd be compared with [options]
      // and the Expected boolean is result of that comparison.
      const tests = {
        Request(
          route: path,
          method: RequestMethods.get,
          queryParameters: <String, dynamic>{},
        ): true,
        Request(
          route: path + '/url/request/matcher',
          method: RequestMethods.post,
          queryParameters: <String, dynamic>{},
        ): false,
      };

      tests.forEach((request, expected) {
        expect(
          urlRequestMatcher.matches(options, request),
          expected,
        );
      });
    });
  });
}
