import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

const String path = '/test';

void main() {
  group('RequestOptions matchers', () {
    test('general truthy test', () {
      // These RequestOptions and Request properties are required defaults.
      final options = RequestOptions(
        path: path,
        method: 'GET',
        // Necessary or is set to null.
        contentType: Headers.jsonContentType,
        headers: {Headers.contentTypeHeader: Headers.jsonContentType},
        queryParameters: {},
      );

      const request = Request(
        route: path,
        method: RequestMethods.GET,
        queryParameters: {},
      );

      expect(options.matchesRequest(request), true);
    });

    group('matches', () {
      RequestOptions options;

      setUp(() {
        options = RequestOptions(
          path: path,
          method: 'GET',
          contentType: Headers.jsonContentType,
          headers: {Headers.contentTypeHeader: Headers.jsonContentType},
          queryParameters: {},
        );
      });

      group('map', () {
        test('exactly', () {
          const actual = {
            'a': 'a',
            'b': 'b',
          };

          const expected = {
            'a': 'a',
            'b': 'b',
          };

          expect(options.matches(actual, expected), true);
        });

        test('uses matchers to validate', () {
          const actual = {
            'a': 'a',
            'b': 'b',
            'c': '123',
            'd': 123,
          };

          const expected = {
            'a': Matchers.any,
            'b': 'b',
            'c': Matchers.number,
            'd': Matchers.integer,
          };

          expect(options.matches(actual, expected), true);
        });

        test('uses matchers but does not validate', () {
          const actual = {
            'a': 'a',
            'b': 'b',
            'c': '123A',
            'd': 123.0,
          };

          const expected = {
            'a': Matchers.any,
            'b': 'b',
            'c': Matchers.number,
            'd': Matchers.decimal,
          };

          expect(options.matches(actual, expected), false);
        });
      });

      group('list', () {
        test('exactly', () {
          const actual = ['a', 'b'];
          const expected = ['a', 'b'];

          expect(options.matches(actual, expected), true);
        });

        test('uses matchers to validate', () {
          const actual = ['a', false, '123', 123];
          const expected = [
            Matchers.any,
            Matchers.boolean,
            Matchers.number,
            Matchers.number,
          ];

          expect(options.matches(actual, expected), true);
        });

        test('uses matchers but does not validate', () {
          const actual = ['a', 'b', '123A', 123];
          const expected = [
            Matchers.any,
            Matchers.string,
            Matchers.number,
            Matchers.number,
          ];

          expect(options.matches(actual, expected), false);
        });
      });

      group('Dio request with matchers', () {
        Dio dio;

        const data = {'message': 'Test!'};

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
              'any': Matchers.any,
              'boolean': Matchers.boolean,
              'integer': Matchers.integer,
              'decimal': Matchers.decimal,
              'string': Matchers.string,
              'pattern': Matchers.pattern('TEST'),
              'regexp': Matchers.regExp(RegExp(r'([a-z]{3} ?){3}')),
              'strict': 'match',
              'map': {
                'a': Matchers.any,
                'b': 'b',
              },
              'list': ['a', 'b'],
            },
            headers: {
              'content-type': Matchers.pattern('application'),
              'content-length': Matchers.number,
            },
            handler: (response) => response.reply(statusCode, data),
          );

          response = await dio.post('/post-any-data', data: {
            'any': '201',
            'boolean': 'FalsE',
            'integer': 3902,
            'decimal': '32.134',
            'string': '',
            'pattern': 'this is a test with ',
            'regexp': 'abc def hij',
            'strict': 'match',
            'map': {
              'a': 'a',
              'b': 'b',
            },
            'list': ['a', 'b'],
          });

          expect({'message': 'Test!'}, response.data);
        });

        test('mocks date formatted POST request as intended', () async {
          dioAdapter = DioAdapter();

          dio.httpClientAdapter = dioAdapter;

          const pattern = r'(0?[1-9]|[12][0-9]|3[01])\-(0?[1-9]|1[012])\-\d{4}';

          dioAdapter.onPost(
            path,
            data: {'date': Matchers.pattern(pattern)},
            headers: {
              Headers.contentTypeHeader: Matchers.pattern('application'),
              Headers.contentLengthHeader: Matchers.integer,
            },
            handler: (response) => response.reply(statusCode, data),
          );

          response = await dio.post(path, data: {'date': '04-01-2021'});

          expect({'message': 'Test!'}, response.data);
        });
      });
    });
  });
}
