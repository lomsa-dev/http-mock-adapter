import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:logger/logger.dart';
import 'package:test/test.dart';

void main() {
  late Dio dio;
  late DioInterceptor dioInterceptor1;
  late DioInterceptor dioInterceptor2;

  setUp(() {
    dio = Dio();
  });

  group('DioInterceptor -', () {
    test('if failOnMissingMock is false do not fail on missing mock', () async {
      dioInterceptor1 = DioInterceptor(dio: dio, failOnMissingMock: false);
      dioInterceptor2 = DioInterceptor(dio: dio, failOnMissingMock: false);

      dioInterceptor1.onGet(
        '/interceptor-1-route',
        (server) => server.reply(
          200,
          {'message': 'Success from interceptor 1'},
        ),
      );
      dioInterceptor2.onGet(
        '/interceptor-2-route',
        (server) => server.reply(
          200,
          {'message': 'Success from interceptor 2'},
        ),
      );

      final int1Response = await dio.get('/interceptor-1-route');
      expect(int1Response.data, {'message': 'Success from interceptor 1'});

      final int2Response = await dio.get('/interceptor-2-route');
      expect(int2Response.data, {'message': 'Success from interceptor 2'});

      final googleResponse = await dio.get('https://google.com');
      expect(googleResponse.statusCode, 200);
    });
    test('if printLogs is true we should see logs on mocked calls', () async {
      dioInterceptor1 = DioInterceptor(dio: dio, printLogs: true);

      dio.interceptors.add(dioInterceptor1);

      dioInterceptor1.onGet(
          '/interceptor-1-route', (server) => server.reply(200, 'OK'));

      final capturedLogs = <OutputEvent>[];
      Logger.addOutputListener((event) {
        capturedLogs.add(event);
      });

      await dio.get('/interceptor-1-route');

      expect(capturedLogs.first.origin.message,
          'Matched request: GET /interceptor-1-route');
      expect(capturedLogs.first.origin.level, Level.debug);
    });
    test('if printLogs is false we should not see logs on mocked calls',
        () async {
      dioInterceptor1 = DioInterceptor(dio: dio, printLogs: false);

      dio.interceptors.add(dioInterceptor1);

      dioInterceptor1.onGet(
          '/interceptor-1-route', (server) => server.reply(200, 'OK'));

      final capturedLogs = <OutputEvent>[];
      Logger.addOutputListener((event) {
        capturedLogs.add(event);
      });

      await dio.get('/interceptor-1-route');

      expect(capturedLogs.length, 0);
    });
  });
}
