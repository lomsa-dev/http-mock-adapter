import 'dart:math';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;

  const path = 'https://example.com';

  setUpAll(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
  });

  group('History', () {
    group('resets after each test call:', () {
      double data;
      Response<dynamic> response;

      tearDown(() => dioAdapter.reset());

      void expectRandomResponse() async {
        data = Random().nextDouble();

        dioAdapter.onGet(
          path,
          (server) => server.reply(200, data),
        );

        response = await dio.get(path);

        expect(data, response.data);

        // Affirm that the length of history's list is one due to reset.
        expect(dioAdapter.history.length, 1);
      }

      for (var index in Iterable<int>.generate(10)) {
        test('Test #${index + 1}', () => expectRandomResponse());
      }
    });

    test('test MockDataCallback', () async {
      var data = {'id': 1, 'name': 'mock'};
      Response<dynamic> response;

      dioAdapter.onPost(
        path,
        (server) => server.reply(200, data),
        data: (options) {
          options = options as RequestOptions;
          return options.data;
        },
      );

      response = await dio.post(path, data: data);

      expect(data, response.data);
    });

    test('throws AssertionError when unable to find mocked route', () async {
      expect(
        () async => await dio.get('/undefined'),
        throwsA(
          predicate(
            (DioError dioError) => dioError.message.startsWith(
              'Assertion failed',
            ),
          ),
        ),
      );
    });
  });
}
