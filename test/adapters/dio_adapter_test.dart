import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  Dio dio;
  DioAdapter dioAdapter;

  Response<dynamic> response;

  const path = 'https://example.com';

  const data = {
    'payload': {
      'data': 'content',
    }
  };

  const statusCode = 200;

  setUpAll(() {
    dio = Dio();

    dioAdapter = DioAdapter();

    dio.httpClientAdapter = dioAdapter;
  });

  group('DioAdapter', () {
    Future<void> testDioAdapter<T>(
      Future<Response<T>> Function() request,
      actual,
    ) async {
      response = await request();

      expect(actual, response.data);
    }

    group('RequestRouted', () {
      test('Test that throws raises custom exception', () async {
        final dioError = DioError(
          error: {'message': 'error'},
          response: Response(statusCode: 500),
          type: DioErrorType.RESPONSE,
        );

        dioAdapter.onGet(path).throws(500, dioError);

        expect(() async => await dio.get(path), throwsA(isA<AdapterError>()));
        expect(() async => await dio.get(path), throwsA(isA<DioError>()));
        expect(
          () async => await dio.get(path),
          throwsA(
            predicate(
              (DioError error) =>
                  error is DioError &&
                  error is AdapterError &&
                  error.message == dioError.error.toString(),
            ),
          ),
        );
      });

      test('mocks requests via onRoute() as intended', () async {
        dioAdapter.onRoute(path).reply(statusCode, data);

        await testDioAdapter(() => dio.get(path), data);
      });

      test('mocks requests via onGet() as intended', () async {
        dioAdapter.onGet(path).reply(statusCode, data);

        await testDioAdapter(() => dio.get(path), data);
      });

      test('mocks requests via onHead() as intended', () async {
        dioAdapter.onHead(path).reply(statusCode, data);

        await testDioAdapter(() => dio.head(path), data);
      });

      test('mocks requests via onPost() as intended', () async {
        dioAdapter.onPost(path).reply(statusCode, data);

        await testDioAdapter(() => dio.post(path), data);
      });

      test('mocks requests via onPut() as intended', () async {
        dioAdapter.onPut(path).reply(statusCode, data);

        await testDioAdapter(() => dio.put(path), data);
      });

      test('mocks requests via onDelete() as intended', () async {
        dioAdapter.onDelete(path).reply(statusCode, data);

        await testDioAdapter(() => dio.delete(path), data);
      });

      test('mocks requests via onPatch() as intended', () async {
        dioAdapter.onPatch(path).reply(statusCode, data);

        await testDioAdapter(() => dio.patch(path), data);
      });

      test('mocks multiple requests sequantially as intended', () async {
        dioAdapter.onPost('/route', data: {'post': '201'}).reply(201, {
          'message': 'Post!',
        });

        response = await dio.post('/route', data: {'post': '201'});

        expect({'message': 'Post!'}, response.data);

        dioAdapter.onPatch('/routes', data: {'patch': '207'}).reply(207, {
          'message': 'Patch!',
        });

        response = await dio.patch('/routes', data: {'patch': '207'});
        expect({'message': 'Patch!'}, response.data);

        dioAdapter.onGet('/api').reply(200, {
          'message': 'Get!',
        });

        response = await dio.get('/api');

        expect({'message': 'Get!'}, response.data);
      });

      test('mocks multiple requests non-sequantially as intended', () async {
        dioAdapter
            .onGet('/first-route')
            .reply(200, {'message': 'First!'})
            .onGet('/second-route')
            .reply(200, {'message': 'Second!'})
            .onPost('/second-route')
            .reply(200, {'message': 'Second again!'})
            .onGet('/third-route')
            .reply(200, {'message': 'Third!'});

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
            .onGet('/route')
            .reply(201, {'message': 'Unbreakable...'})
            .onGet('/api')
            .reply(200, {'message': 'Chain!'});

        response = await dio.get('/route');
        expect({'message': 'Unbreakable...'}, response.data);

        response = await dio.get('/api');
        expect({'message': 'Chain!'}, response.data);
      });
    });
  });
}
