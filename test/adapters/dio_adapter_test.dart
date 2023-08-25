import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
  });

  group(DioAdapter, () {
    test('closes itself by force', () async {
      dioAdapter.close();

      dioAdapter.onGet(
        '/route',
        (server) => server.reply(200, {'message': 'Success'}),
      );

      expect(
        () async => await dio.get('/route'),
        throwsA(predicate((DioException dioError) =>
            dioError.error is ClosedException &&
            dioError.error.toString() ==
                'ClosedException: Cannot establish connection after [DioAdapter] got closed!')),
      );
    });

    test('delays reply', () async {
      const delay = 5000;

      dioAdapter.onGet(
        '/route',
        (server) => server.reply(
          200,
          {'message': 'Success'},
          delay: const Duration(milliseconds: delay),
        ),
      );

      expectFakeDelay(() => dio.get('/route'), delay);
    });

    test('delays error', () async {
      const delay = 5000;
      final dioError = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: 'path'),
      );

      dioAdapter.onGet(
        '/route',
        (server) => server.throws(
          404,
          dioError,
          delay: const Duration(milliseconds: delay),
        ),
      );

      expectFakeDelay(
        () async {
          try {
            await dio.get('/route');
          } on DioException catch (_) {
            // Ignore expected error.
          }
        },
        delay,
      );
    });
  });
}
