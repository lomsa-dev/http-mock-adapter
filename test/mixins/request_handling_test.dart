import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/mixins/mixins.dart';
import 'package:test/test.dart';

void main() {
  group(RequestHandling, () {
    final implementors = {
      DioAdapter: ({required Dio dio}) => DioAdapter(dio: dio),
      DioInterceptor: ({required Dio dio}) => DioInterceptor(dio: dio),
    };

    const path = 'https://example.com';
    const data = {
      'payload': {
        'data': 'content',
      }
    };

    const statusCode = 200;

    for (final requestHandling in implementors.entries) {
      late Dio dio;
      late RequestHandling tester;

      Future<void> testRequest<T>(
        Future<Response<T>> request,
        expected,
      ) async {
        final response = await request;
        expect(response.data, expected);
      }

      group(requestHandling.key, () {
        setUp(() {
          dio = Dio();
          tester = requestHandling.value(dio: dio);
        });

        test('uses default values from Dio', () async {
          tester.onGet(path, (server) => server.reply(200, {}));

          testRequest(
            dio.get(path),
            {},
          );

          dio = Dio(BaseOptions(
            method: RequestMethods.post.name,
            headers: {
              Headers.contentTypeHeader: Headers.jsonContentType,
              Headers.contentLengthHeader: Matchers.integer,
            },
          ));
          tester = DioAdapter(dio: dio);

          tester.onPost(
            path,
            (server) => server.reply(200, data),
            data: data,
          );

          testRequest(
            dio.post(path, data: data),
            data,
          );
        });

        test('sets default headers for form-data', () async {
          tester.onPut(
            path,
            (server) => server.reply(200, {}),
            data: FormData.fromMap({
              'foo': 'bar',
            }),
            headers: <String, Object?>{
              Headers.contentTypeHeader:
                  Matchers.pattern('multipart/form-data; boundary=.*'),
              Headers.contentLengthHeader: Matchers.integer,
            },
          );

          testRequest(
            dio.put(
              path,
              data: FormData.fromMap({
                'foo': 'bar',
              }),
            ),
            {},
          );
        });

        test('sets default headers with custom request encoder', () async {
          dio = Dio(BaseOptions(
            requestEncoder: (request, options) => utf8.encode(request),
          ));
          tester = DioAdapter(dio: dio);

          tester.onPut(
            '/example',
            (server) => server.reply(200, {}),
            data: {
              'foo': 'bar',
            },
            headers: <String, Object?>{
              Headers.contentTypeHeader: Headers.jsonContentType,
              Headers.contentLengthHeader: Matchers.integer,
            },
          );

          testRequest(
            dio.put(
              '/example',
              data: {
                'foo': 'bar',
              },
            ),
            {},
          );
        });

        test('throws raises custom exception', () async {
          final dioError = DioError(
            error: {'message': 'error'},
            requestOptions: RequestOptions(path: path),
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: path),
            ),
            type: DioErrorType.response,
          );

          tester.onGet(
            path,
            (server) => server.throws(500, dioError),
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
          tester.onRoute(
            path,
            (server) => server.reply(statusCode, data),
            request: const Request(),
          );

          await testRequest(dio.get(path), data);
        });

        test('mocks requests via onGet() as intended', () async {
          tester.onGet(
            path,
            (server) => server.reply(statusCode, data),
          );

          await testRequest(dio.get(path), data);
        });

        test('mocks requests via onHead() as intended', () async {
          tester.onHead(
            path,
            (server) => server.reply(statusCode, data),
          );

          await testRequest(dio.head(path), data);
        });

        test('mocks requests via onPost() as intended', () async {
          tester.onPost(
            path,
            (server) => server.reply(statusCode, data),
          );

          await testRequest(dio.post(path), data);
        });

        test('mocks requests via onPut() as intended', () async {
          tester.onPut(
            path,
            (server) => server.reply(statusCode, data),
          );

          await testRequest(dio.put(path), data);
        });

        test('mocks requests via onDelete() as intended', () async {
          tester.onDelete(
            path,
            (server) => server.reply(statusCode, data),
          );

          await testRequest(dio.delete(path), data);
        });

        test('mocks requests via onPatch() as intended', () async {
          tester.onPatch(
            path,
            (server) => server.reply(statusCode, data),
          );

          await testRequest(dio.patch(path), data);
        });

        test('mocks requests with query parameters', () async {
          const books = [
            {'name': 'First Book'},
            {'name': 'Second Book'},
          ];

          tester.onGet(
            '/search',
            (server) => server.reply(200, books),
            queryParameters: {'query': 'book'},
          );

          testRequest(
            dio.get(
              '/search',
              queryParameters: {'query': 'book'},
            ),
            books,
          );
        });

        test('mocks multiple requests sequentially as intended', () async {
          tester.onPost(
            '/route',
            (server) => server.reply(201, {
              'message': 'Post!',
            }),
            data: {'post': '201'},
          );

          testRequest(
            dio.post('/route', data: {'post': '201'}),
            {'message': 'Post!'},
          );

          tester.onPatch(
            '/routes',
            (server) => server.reply(207, {
              'message': 'Patch!',
            }),
            data: {'patch': '207'},
          );

          testRequest(
            dio.patch('/routes', data: {'patch': '207'}),
            {'message': 'Patch!'},
          );

          tester.onGet(
            '/api',
            (server) => server.reply(200, {
              'message': 'Get!',
            }),
          );

          testRequest(
            dio.get('/api'),
            {'message': 'Get!'},
          );
        });

        test('mocks multiple requests non-sequentially as intended', () async {
          tester
            ..onGet(
              '/first-route',
              (server) => server.reply(200, {'message': 'First!'}),
            )
            ..onGet(
              '/second-route',
              (server) => server.reply(200, {'message': 'Second!'}),
            )
            ..onPost(
              '/second-route',
              (server) => server.reply(200, {'message': 'Second again!'}),
            )
            ..onGet(
              '/third-route',
              (server) => server.reply(200, {'message': 'Third!'}),
            );

          testRequest(
            dio.get('/second-route'),
            {'message': 'Second!'},
          );
          testRequest(
            dio.get('/third-route'),
            {'message': 'Third!'},
          );
          testRequest(
            dio.get('/first-route'),
            {'message': 'First!'},
          );
          testRequest(
            dio.post('/second-route'),
            {'message': 'Second again!'},
          );
        });

        test('mocks multiple requests by chaining methods as intended',
            () async {
          tester
            ..onGet(
              '/route',
              (server) => server.reply(201, {'message': 'Unbreakable...'}),
            )
            ..onGet(
              '/api',
              (server) => server.reply(200, {'message': 'Chain!'}),
            );

          testRequest(
            dio.get('/route'),
            {'message': 'Unbreakable...'},
          );
          testRequest(
            dio.get('/api'),
            {'message': 'Chain!'},
          );
        });

        test('mocks route pattern', () async {
          tester.onGet(
            RegExp(r'/test-route/[0-9]{6}'),
            (server) => server.reply(200, {'message': 'Test!'}),
          );

          testRequest(
            dio.get('/test-route/123456'),
            {'message': 'Test!'},
          );
        });

        test('returns a new response every time for the same request',
            () async {
          tester.onGet(
            '/route',
            (server) => server.reply(200, {'message': 'Success'}),
          );

          testRequest(
            dio.get('/route'),
            {'message': 'Success'},
          );
          testRequest(
            dio.get('/route'),
            {'message': 'Success'},
          );
        });
      });
    }
  });
}
