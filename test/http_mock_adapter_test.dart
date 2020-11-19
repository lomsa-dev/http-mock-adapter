import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/interceptors/dio_interceptor.dart';
import 'package:http_mock_adapter/src/utils.dart';
import 'package:mockito/mockito.dart';

void main() {
  Dio dio;

  Map<String, dynamic> data;
  const path = 'https://example.com';

  Response<dynamic> response;
  final statusCode = 200;

  group('DioInterceptor', () {
    DioInterceptor dioInterceptor;

    data = {'message': 'Test!'};

    setUpAll(() {
      dio = Dio();

      dioInterceptor = DioInterceptor();

      dio.interceptors.add(dioInterceptor);
    });

    Future<void> _testDioInterceptor<T>(
      Future<Response<T>> Function() request,
      actual,
    ) async {
      response = await request();

      expect(jsonEncode(actual), response.data);
    }

    group('RequestRouted', () {
      test('mocks requests via onRoute() as intended', () async {
        dioInterceptor.onRoute(path).reply(statusCode, data);

        await _testDioInterceptor(() => dio.get(path), data);
      });

      test('mocks requests via onGet() as intended', () async {
        dioInterceptor.onGet(path).reply(statusCode, data);

        await _testDioInterceptor(() => dio.get(path), data);
      });

      test('mocks requests via onHead() as intended', () async {
        dioInterceptor.onHead(path).reply(statusCode, data);

        await _testDioInterceptor(() => dio.head(path), data);
      });

      test('mocks requests via onPost() as intended', () async {
        dioInterceptor.onPost(path).reply(statusCode, data);

        await _testDioInterceptor(() => dio.post(path), data);
      });

      test('mocks requests via onPut() as intended', () async {
        dioInterceptor.onPut(path).reply(statusCode, data);

        await _testDioInterceptor(() => dio.put(path), data);
      });

      test('mocks requests via onDelete() as intended', () async {
        dioInterceptor.onDelete(path).reply(statusCode, data);

        await _testDioInterceptor(() => dio.delete(path), data);
      });

      test('mocks requests via onPatch() as intended', () async {
        dioInterceptor.onPatch(path).reply(statusCode, data);

        await _testDioInterceptor(() => dio.patch(path), data);
      });
    });

    test('mocks multiple requests sequantially by method chaining', () async {
      final dio = Dio();

      final dioInterceptor = DioInterceptor();

      dioInterceptor
          .onGet(path)
          .reply(statusCode, data)
          .onPost(path)
          .reply(statusCode, data)
          .onPatch(path)
          .reply(statusCode, data);

      dio.interceptors.add(dioInterceptor);

      response = await dio.get(path);
      expect(response.data, jsonEncode(data));

      response = await dio.post(path);
      expect(response.data, jsonEncode(data));

      response = await dio.patch(path);
      expect(response.data, jsonEncode(data));
    });
  });

  group('DioAdapter', () {
    DioAdapter dioAdapter;

    data = {'message': 'Test!'};

    setUpAll(() {
      dio = Dio();

      dioAdapter = DioAdapter();

      dio.httpClientAdapter = dioAdapter;
    });

    group('RequestRouted', () {
      Future<void> _testDioAdapter<T>(
        Future<Response<T>> Function() request,
        actual,
      ) async {
        response = await request();

        expect(jsonEncode(actual), response.data);
      }

      test('mocks requests via onRoute() as intended', () async {
        dioAdapter.onRoute(path).reply(statusCode, data);

        await _testDioAdapter(() => dio.get(path), data);
      });

      test('mocks requests via onGet() as intended', () async {
        dioAdapter.onGet(path).reply(statusCode, data);

        await _testDioAdapter(() => dio.get(path), data);
      });

      test('mocks requests via onHead() as intended', () async {
        dioAdapter.onHead(path).reply(statusCode, data);

        await _testDioAdapter(() => dio.head(path), data);
      });

      test('mocks requests via onPost() as intended', () async {
        dioAdapter.onPost(path).reply(statusCode, data);

        await _testDioAdapter(() => dio.post(path), data);
      });

      test('mocks requests via onPut() as intended', () async {
        dioAdapter.onPut(path).reply(statusCode, data);

        await _testDioAdapter(() => dio.put(path), data);
      });

      test('mocks requests via onDelete() as intended', () async {
        dioAdapter.onDelete(path).reply(statusCode, data);

        await _testDioAdapter(() => dio.delete(path), data);
      });

      test('mocks requests via onPatch() as intended', () async {
        dioAdapter.onPatch(path).reply(statusCode, data);

        await _testDioAdapter(() => dio.patch(path), data);
      });

      test('mocks multiple requests sequantially as intended', () async {
        dioAdapter = DioAdapter();

        dio.httpClientAdapter = dioAdapter;

        dioAdapter.onPost('/route', data: {'post': '201'}).reply(201, {
          'message': 'Post!',
        });

        response = await dio.post('/route');

        expect(jsonEncode({'message': 'Post!'}), response.data);

        dioAdapter.onPatch('/route', data: {'patch': '404'}).reply(404, {
          'message': 'Patch!',
        });

        response = await dio.patch('/route');

        expect(jsonEncode({'message': 'Patch!'}), response.data);

        dioAdapter.onGet('/api', data: {'get': '200'}).reply(200, {
          'message': 'Get!',
        });

        response = await dio.get('/api');

        expect(jsonEncode({'message': 'Get!'}), response.data);
      });

      test('mocks multiple requests non-sequantially as intended', () async {
        dioAdapter = DioAdapter();

        dio.httpClientAdapter = dioAdapter;

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
        expect(jsonEncode({'message': 'Second!'}), response.data);

        response = await dio.get('/third-route');
        expect(jsonEncode({'message': 'Third!'}), response.data);

        response = await dio.get('/first-route');
        expect(jsonEncode({'message': 'First!'}), response.data);

        response = await dio.post('/second-route');
        expect(jsonEncode({'message': 'Second again!'}), response.data);
      });

      test('mocks multiple requests by chaining methods as intended', () async {
        dioAdapter = DioAdapter();

        dio.httpClientAdapter = dioAdapter;

        dioAdapter
            .onGet('/route')
            .reply(201, {'message': 'Unbreakable...'})
            .onGet('/api')
            .reply(200, {'message': 'Chain!'});

        response = await dio.get('/route');
        expect(jsonEncode({'message': 'Unbreakable...'}), response.data);

        response = await dio.get('/api');
        expect(jsonEncode({'message': 'Chain!'}), response.data);
      });
    });
  });

  test('paths are parsed into mock filenames as intended', () {
    var actual = '-example';

    expect(actual, getMockFileName('example'));
    expect(actual, getMockFileName('/example'));
    expect(actual, getMockFileName('example.com'));
    expect(actual, getMockFileName('api.example.com'));
    expect(actual, getMockFileName('www.example.com'));
    expect(actual, getMockFileName('http://example.com'));
    expect(actual, getMockFileName('https://example.com'));

    actual = '-example/route';

    expect(actual, getMockFileName('example/route'));
    expect(actual, getMockFileName('/example/route'));
    expect(actual, getMockFileName('example/route.com'));
    expect(actual, getMockFileName('api.example/route.com'));
    expect(actual, getMockFileName('www.example/route.com'));
    expect(actual, getMockFileName('http://example/route.com'));
    expect(actual, getMockFileName('https://example/route.com'));
  });

  group('DioAdapterMockito', () {
    DioAdapterMockito dioAdapterMockito;

    setUpAll(() {
      dio = Dio();

      dioAdapterMockito = DioAdapterMockito();

      dio.httpClientAdapter = dioAdapterMockito;
    });

    test('mocks any request/response via fetch method', () async {
      final responsePayload = jsonEncode({'response_code': '200'});

      final responseBody = ResponseBody.fromString(
        responsePayload,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

      final expected = {'response_code': '200'};

      when(dioAdapterMockito.fetch(any, any, any))
          .thenAnswer((_) async => responseBody);

      response = await dio.get('/route');

      expect(expected, response.data);
    });
  });
}
