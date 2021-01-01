import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

const String PATH = '/test';

void main() {
  group('Request Options matchers', () {
    test('general truthy test', () {
      /// these RequestOptions and Request properties are required defaults
      var options = RequestOptions(
        path: PATH,
        method: 'GET',
        contentType: Headers.jsonContentType, // necessary or is set to null
        headers: {Headers.contentTypeHeader: Headers.jsonContentType},
        queryParameters: {},
      );

      var req = Request(
        route: PATH,
        method: RequestMethods.GET,
        queryParameters: {},
      );

      expect(options.matchesRequest(req), true);
    });

    group('matches', () {
      RequestOptions options;

      setUp(() {
        options = RequestOptions(
          path: PATH,
          method: 'GET',
          contentType: Headers.jsonContentType,
          headers: {Headers.contentTypeHeader: Headers.jsonContentType},
          queryParameters: {},
        );
      });

      group('map', () {
        test('exactly', () {
          var a = {
            'a': 'a',
            'b': 'b',
          };
          var b = {
            'a': 'a',
            'b': 'b',
          };

          expect(options.matches(a, b), true);
        });

        test('uses matchers to validate', () {
          var a = {
            'a': 'a',
            'b': 'b',
            'c': '123',
            'd': 123,
          };
          var b = {
            'a': anyValue,
            'b': 'b',
            'c': anyNumber,
            'd': anyNumber,
          };

          expect(options.matches(a, b), true);
        });

        test('uses matchers but does not validate', () {
          var a = {
            'a': 'a',
            'b': 'b',
            'c': '123A',
            'd': 123,
          };
          var b = {
            'a': anyValue,
            'b': 'b',
            'c': anyNumber,
            'd': anyNumber,
          };

          expect(options.matches(a, b), false);
        });
      });

      group('list', () {
        test('exactly', () {
          var a = ['a', 'b'];
          var b = ['a', 'b'];

          expect(options.matches(a, b), true);
        });

        test('uses matchers to validate', () {
          var a = ['a', 'b', '123', 123];
          var b = [anyValue, 'b', anyNumber, anyNumber];

          expect(options.matches(a, b), true);
        });

        test('uses matchers but does not validate', () {
          var a = ['a', 'b', '123A', 123];
          var b = [anyValue, 'b', anyNumber, anyNumber];

          expect(options.matches(a, b), false);
        });
      });

      group('Dio request with matchers', () {
        Dio dio;

        Map<String, dynamic> data = {'message': 'Test!'};
        const path = 'https://example.com';

        Response<dynamic> response;
        const statusCode = 200;
        DioAdapter dioAdapter;

        setUpAll(() {
          dio = Dio();

          dioAdapter = DioAdapter();

          dio.httpClientAdapter = dioAdapter;
        });

        test('mocks requests via onPost() with matchers as intended', () async {
          dioAdapter = DioAdapter();

          dio.httpClientAdapter = dioAdapter;

          dioAdapter.onPost(
            '/post-any-data',
            data: {
              'any': anyValue,
              'pattern': RegExpMatcher(pattern: 'TEST'),
              'regexp': RegExpMatcher(regexp: RegExp(r'([a-z]{3} ?){3}')),
              'strict': 'match',
              'map': {
                'a': anyValue,
                'b': 'b',
              },
              'list': ['a', 'b'],
            },
            headers: {
              'content-type': RegExpMatcher(pattern: 'application'),
              'content-length': anyNumber,
            },
          ).reply(statusCode, data);

          response = await dio.post('/post-any-data', data: {
            'any': '201',
            'pattern': 'this is a test with ',
            'regexp': 'abc def hij',
            'strict': 'match',
            'map': {
              'a': 'a',
              'b': 'b',
            },
            'list': ['a', 'b'],
          });

          expect(jsonEncode({'message': 'Test!'}), response.data);
        });
      });
    });
  });
}
