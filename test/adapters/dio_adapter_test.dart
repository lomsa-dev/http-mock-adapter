import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

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

    /// Invokes the [callback] wrapped in a fake timer, elapsing time
    /// in [steps] equal increments until [expectedDelayMs] is reached,
    /// at which point the callback is expected to have resolved.
    void expectFakeDelay(Future Function() callback, int expectedDelayMs,
            [int steps = 4]) =>
        fakeAsync((async) {
          final stepDelay =
              Duration(milliseconds: (expectedDelayMs / steps).ceil());
          bool completed = false;
          final f = callback();
          f.then((value) => completed = true);

          // Allow for one extra step in case the time matches exactly
          // and there's a small deviation in the delay.
          for (var i = 0; i < (steps + 1); i++) {
            async.elapse(stepDelay);
            async.flushMicrotasks();
            final elapsed = async.elapsed.inMilliseconds;
            if (completed) {
              expect(elapsed, greaterThanOrEqualTo(expectedDelayMs));
              break;
            } else {
              expect(elapsed, lessThanOrEqualTo(expectedDelayMs));
            }
          }

          expect(completed, isTrue,
              reason: 'Completed time delay without completing future.');
        });

    test('delays reply', () async {
      const delay = 5000;

      dioAdapter.onGet('/route', (server) {
        server.reply(200, {'message': 'Success'},
            delay: const Duration(milliseconds: delay));
      });

      expectFakeDelay(() => dio.get('/route'), delay);
    });

    test('delays error', () async {
      const delay = 5000;
      final dioError = DioError(
        requestOptions: RequestOptions(
          path: 'path',
        ),
        type: DioErrorType.response,
      );

      dioAdapter.onGet('/route', (server) {
        server.throws(404, dioError,
            delay: const Duration(milliseconds: delay));
      });

      expectFakeDelay(() async {
        try {
          await dio.get('/route');
        } on DioError catch (_) {
          // Ignore expected error
        }
      }, delay);
    });
  });
}
