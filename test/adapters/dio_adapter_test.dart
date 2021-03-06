import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:test/test.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;

  Response<dynamic> response;

  const path = 'https://example.com';
  const data = {
    'payload': {
      'data': 'content',
    }
  };
  const statusCode = 200;

  setUp(() {
    dioAdapter = DioAdapter();
    dio = Dio()..httpClientAdapter = dioAdapter;
  });

  group('DioAdapter', () {
    Future<void> testDioAdapter<T>(
      Future<Response<T>> Function() request,
      actual,
    ) async {
      response = await request();

      expect(actual, response.data);
    }

    test('uses default values from constructor', () async {
      dioAdapter.onGet('/example', (request) => request.reply(200, {}));

      response = await dio.get('/example');

      expect(response.data, {});

      dioAdapter
        ..method = RequestMethods.post
        ..data = {}
        ..headers = {
          Headers.contentTypeHeader: Headers.jsonContentType,
          Headers.contentLengthHeader: Matchers.integer,
        };

      dioAdapter.onRoute(
        '/example',
        (request) => request.reply(200, {}),
        request: const Request(),
      );

      response = await dio.post(
        '/example',
        data: {},
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.jsonContentType,
          },
        ),
      );

      expect(response.data, {});
    });

    group('RequestRouted', () {
      test('Test that throws raises custom exception', () async {
        final dioError = DioError(
          error: {'message': 'error'},
          requestOptions: RequestOptions(path: path),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: path),
          ),
          type: DioErrorType.response,
        );

        dioAdapter.onGet(
          path,
          (request) => request.throws(500, dioError),
        );

        expect(() async => await dio.get(path), throwsA(isA<MockDioError>()));
        expect(() async => await dio.get(path), throwsA(isA<DioError>()));
        expect(
          () async => await dio.get(path),
          throwsA(
            predicate(
              (DioError error) =>
                  error is DioError &&
                  error is MockDioError &&
                  error.message == dioError.error.toString(),
            ),
          ),
        );
      });

      test('mocks requests via onRoute() as intended', () async {
        dioAdapter.onRoute(
          path,
          (request) => request.reply(statusCode, data),
          request: const Request(),
        );

        await testDioAdapter(() => dio.get(path), data);
      });

      test('mocks requests via onGet() as intended', () async {
        dioAdapter.onGet(
          path,
          (request) => request.reply(statusCode, data),
        );

        await testDioAdapter(() => dio.get(path), data);
      });

      test('mocks requests via onHead() as intended', () async {
        dioAdapter.onHead(
          path,
          (request) => request.reply(statusCode, data),
        );

        await testDioAdapter(() => dio.head(path), data);
      });

      test('mocks requests via onPost() as intended', () async {
        dioAdapter.onPost(
          path,
          (request) => request.reply(statusCode, data),
        );

        await testDioAdapter(() => dio.post(path), data);
      });

      test('mocks requests via onPut() as intended', () async {
        dioAdapter.onPut(
          path,
          (request) => request.reply(statusCode, data),
        );

        await testDioAdapter(() => dio.put(path), data);
      });

      test('mocks requests via onDelete() as intended', () async {
        dioAdapter.onDelete(
          path,
          (request) => request.reply(statusCode, data),
        );

        await testDioAdapter(() => dio.delete(path), data);
      });

      test('mocks requests via onPatch() as intended', () async {
        dioAdapter.onPatch(
          path,
          (request) => request.reply(statusCode, data),
        );

        await testDioAdapter(() => dio.patch(path), data);
      });

      test('mocks requests with query parameters', () async {
        const books = [
          {'name': 'First Book'},
          {'name': 'Second Book'},
        ];

        dioAdapter.onGet(
          '/search',
          (request) => request.reply(200, books),
          queryParameters: {'query': 'book'},
        );

        response = await dio.get(
          '/search',
          queryParameters: {'query': 'book'},
        );

        expect(books, response.data);
      });

      test('mocks multiple requests sequentially as intended', () async {
        dioAdapter.onPost(
          '/route',
          (request) => request.reply(201, {
            'message': 'Post!',
          }),
          data: {'post': '201'},
        );

        response = await dio.post('/route', data: {'post': '201'});

        expect({'message': 'Post!'}, response.data);

        dioAdapter.onPatch(
          '/routes',
          (request) => request.reply(207, {
            'message': 'Patch!',
          }),
          data: {'patch': '207'},
        );

        response = await dio.patch('/routes', data: {'patch': '207'});
        expect({'message': 'Patch!'}, response.data);

        dioAdapter.onGet(
          '/api',
          (request) => request.reply(200, {
            'message': 'Get!',
          }),
        );

        response = await dio.get('/api');

        expect({'message': 'Get!'}, response.data);
      });

      test('mocks multiple requests non-sequentially as intended', () async {
        dioAdapter
          ..onGet(
            '/first-route',
            (request) => request.reply(200, {'message': 'First!'}),
          )
          ..onGet(
            '/second-route',
            (request) => request.reply(200, {'message': 'Second!'}),
          )
          ..onPost(
            '/second-route',
            (request) => request.reply(200, {'message': 'Second again!'}),
          )
          ..onGet(
            '/third-route',
            (request) => request.reply(200, {'message': 'Third!'}),
          );

        response = await dio.get('/second-route');
        expect({'message': 'Second!'}, response.data);

        response = await dio.get('/third-route');
        expect({'message': 'Third!'}, response.data);

        response = await dio.get('/first-route');
        expect({'message': 'First!'}, response.data);

        response = await dio.post('/second-route');
        expect({'message': 'Second again!'}, response.data);
      });

      test('mocks multiple requests by chaining methods as intended', () async {
        dioAdapter
          ..onGet(
            '/route',
            (request) => request.reply(201, {'message': 'Unbreakable...'}),
          )
          ..onGet(
            '/api',
            (request) => request.reply(200, {'message': 'Chain!'}),
          );

        response = await dio.get('/route');
        expect({'message': 'Unbreakable...'}, response.data);

        response = await dio.get('/api');
        expect({'message': 'Chain!'}, response.data);
      });

      test('mocks route pattern', () async {
        dioAdapter.onGet(
          RegExp(r'/test-route/[0-9]{6}'),
          (request) => request.reply(200, {'message': 'Test!'}),
        );

        response = await dio.get('/test-route/123456');
        expect({'message': 'Test!'}, response.data);
      });

      test('returns a new response every time for the same request', () async {
        dioAdapter.onGet(
          '/route',
          (request) => request.reply(200, {'message': 'Success'}),
        );

        response = await dio.get('/route');
        expect({'message': 'Success'}, response.data);

        response = await dio.get('/route');
        expect({'message': 'Success'}, response.data);
      });
    });

    test('closes itself by force', () async {
      dioAdapter.close();

      dioAdapter.onGet(
        '/route',
        (request) => request.reply(200, {'message': 'Success'}),
      );

      expect(
        () async => await dio.get('/route'),
        throwsA(
          predicate(
            (DioError dioError) => dioError.message.startsWith(
              'ClosedException',
            ),
          ),
        ),
      );
    });
  });
}
