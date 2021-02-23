import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() async {
  Dio dio;

  Map<String, dynamic> data;

  final payload = jsonEncode({
    'payload': {'data': 'Test data!'},
  });

  const path = 'https://example.com';

  group('DioAdapter', () {
    DioAdapter dioAdapter;

    setUpAll(() {
      dio = Dio();

      dioAdapter = DioAdapter();

      dio.httpClientAdapter = dioAdapter;
    });

    test('mocks the data', () async {
      data = {'message': 'Successfully mocked GET!'};

      dioAdapter.onGet(
        'https://api.mocki.io/v1/b043df5a',
        handler: (response) => response.reply(200, data),
      );

      final getResponse = await dio.get('https://api.mocki.io/v1/b043df5a');

      expect(getResponse.data, data);
    });

    test('mocks the data with onRoute', () async {
      data = {'message': 'Successfully mocked PATCH!'};

      dioAdapter
          .onRoute(
            path,
            request: Request(method: RequestMethods.PATCH, data: payload),
          )
          .reply(200, data);

      final patchResponse = await dio.patch(path, data: payload);

      expect(patchResponse.data, data);
    });
  });

  group('DioInterceptor', () {
    DioInterceptor dioInterceptor;

    setUpAll(() {
      dio = Dio();

      dioInterceptor = DioInterceptor();

      dio.interceptors.add(dioInterceptor);
    });

    test('mocks the data', () async {
      data = {'message': 'Successfully mocked DELETE!'};

      dioInterceptor.onDelete(
        path,
        handler: (response) => response.reply(200, data),
      );

      final deleteResponse = await dio.delete(path);

      expect(deleteResponse.data, data);

      dioInterceptor.onPut(
        path,
        data: payload,
        handler: (response) => response.reply(200, data),
      );

      final putResponse = await dio.put(path, data: payload);

      expect(putResponse.data, data);
    });
  });

  group('AdapterError/DioError', () {
    DioAdapter dioAdapter;

    setUpAll(() {
      dio = Dio();

      dioAdapter = DioAdapter();

      dio.httpClientAdapter = dioAdapter;
    });

    test('throws custom exception', () async {
      final dioError = DioError(
        error: {'message': 'Some beautiful error!'},
        response: Response(statusCode: 500),
        type: DioErrorType.RESPONSE,
      );

      dioAdapter.onGet(
        path,
        handler: (response) => response.throws(500, dioError),
      );

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
  });
}
