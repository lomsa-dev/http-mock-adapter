import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
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
        throwsA(
          predicate(
            (DioError dioError) => dioError.message.startsWith(
              'ClosedException',
            ),
          ),
        ),
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
      final dioError = DioError(
        type: DioErrorType.response,
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
          } on DioError catch (_) {
            // Ignore expected error.
          }
        },
        delay,
      );
    });
  });
}
