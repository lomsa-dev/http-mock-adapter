import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/interceptors/http_interceptor.dart';
import 'package:http_mock_adapter/src/utils.dart';

const path = 'https://example.com';

void main() {
  group("Interceptor", () {
    MainInterceptor dioInterceptor;
    setUp(() {
      dioInterceptor = MainInterceptor();
    });
    int statusCode = 200;
    final data = {'message': 'Test!'};

    group("RequestRouted test for dioInterceptor", () {
      test("Mocks requests via onRoute() as intended",
          () => dioInterceptor.onRoute(path).reply(statusCode, data));
      test('Mocks requests via onGet() as intended',
          () => dioInterceptor.onGet(path).reply(statusCode, data));

      test('Mocks requests via onHead() as intended',
          () => dioInterceptor.onHead(path).reply(statusCode, data));

      test('Mocks requests via onPost() as intended',
          () => dioInterceptor.onPost(path).reply(statusCode, data));

      test('Mocks requests via onPut() as intended',
          () => dioInterceptor.onPut(path).reply(statusCode, data));

      test('Mocks requests via onDelete() as intended',
          () => dioInterceptor.onDelete(path).reply(statusCode, data));

      test('Mocks requests via onConnect() as intended',
          () => dioInterceptor.onConnect(path).reply(statusCode, data));

      test('Mocks requests via onOptions() as intended',
          () => dioInterceptor.onOptions(path).reply(statusCode, data));

      test('Mocks requests via onTrace() as intended',
          () => dioInterceptor.onTrace(path).reply(statusCode, data));

      test('Mocks requests via onPatch() as intended',
          () => dioInterceptor.onPatch(path).reply(statusCode, data));
    });

    test("Mocks multiple requests sequantially by chaning", () async {
      // Initial dio object
      Dio dio = Dio();

      // Initial interceptor
      MainInterceptor interceptor = MainInterceptor();

      // Chained interceptor
      interceptor
          .onGet(path)
          .reply(statusCode, data)
          .onPost(path)
          .reply(statusCode, data)
          .onPatch(path)
          .reply(statusCode, data);

      // Adding interceptor to dio object
      dio.interceptors.add(interceptor);

      // Testing GET request
      dynamic response = await dio.get(path);
      expect(response.data, data.toString());

      // Testing POST request
      response = await dio.post(path);
      expect(response.data, data.toString());

      // Testing POST request
      response = await dio.patch(path);
      expect(response.data, data.toString());
    });
  });

  group('DioAdapter', () {
    DioAdapter dioAdapter;

    int statusCode = 200;
    final data = {'message': 'Test!'};

    void _testDioAdapter(
      DioAdapter dioAdapter, {
      dynamic actual,
    }) async {
      final dio = Dio();

      dio.httpClientAdapter = dioAdapter;

      final response = await dio.get(path);

      expect(actual, response.data);
    }

    group('RequestRouted', () {
      setUp(() {
        dioAdapter = DioAdapter();
      });

      tearDown(() => _testDioAdapter(dioAdapter, actual: data.toString()));

      test('mocks requests via onRoute() as intended',
          () => dioAdapter.onRoute(path).reply(statusCode, data));

      test('mocks requests via onGet() as intended',
          () => dioAdapter.onGet(path).reply(statusCode, data));

      test('mocks requests via onHead() as intended',
          () => dioAdapter.onHead(path).reply(statusCode, data));

      test('mocks requests via onPost() as intended',
          () => dioAdapter.onPost(path).reply(statusCode, data));

      test('mocks requests via onPut() as intended',
          () => dioAdapter.onPut(path).reply(statusCode, data));

      test('mocks requests via onDelete() as intended',
          () => dioAdapter.onDelete(path).reply(statusCode, data));

      test('mocks requests via onConnect() as intended',
          () => dioAdapter.onConnect(path).reply(statusCode, data));

      test('mocks requests via onOptions() as intended',
          () => dioAdapter.onOptions(path).reply(statusCode, data));

      test('mocks requests via onTrace() as intended',
          () => dioAdapter.onTrace(path).reply(statusCode, data));

      test('mocks requests via onPatch() as intended',
          () => dioAdapter.onPatch(path).reply(statusCode, data));
    });

    test('mocks multiple requests sequantially as intended', () async {
      final dio = Dio();

      dioAdapter = DioAdapter();

      Response<dynamic> response;

      dio.httpClientAdapter = dioAdapter;

      dioAdapter.onPost('/route', data: {'post': '201'}).reply(201, {
        'message': 'Post!',
      });

      response = await dio.post('/route');

      expect({'message': 'Post!'}.toString(), response.data);

      dioAdapter.onPatch('/route', data: {'patch': '404'}).reply(404, {
        'message': 'Patch!',
      });

      response = await dio.patch('/route');

      expect({'message': 'Patch!'}.toString(), response.data);

      dioAdapter.onGet('/api', data: {'get': '200'}).reply(200, {
        'message': 'Get!',
      });

      response = await dio.get('/api');

      expect({'message': 'Get!'}.toString(), response.data);
    });

    test('mocks multiple requests by chaining methods as intended', () async {
      final dio = Dio();

      dioAdapter = DioAdapter();

      Response<dynamic> response;

      dio.httpClientAdapter = dioAdapter;

      dioAdapter
          .onGet('/route')
          .reply(201, {'message': 'Unbreakable...'})
          .onGet('/api')
          .reply(200, {'message': 'Chain!'});

      response = await dio.get('/route');

      expect({'message': 'Unbreakable...'}.toString(), response.data);

      response = await dio.get('/api');

      expect({'message': 'Chain!'}.toString(), response.data);
    });
  });

  test('paths are parsed into mock filenames as intended', () {
    String actual = '-example';

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
}
