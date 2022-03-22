import 'package:test/test.dart';
import 'package:fake_async/fake_async.dart';

/// Invokes the [callback] wrapped in a fake timer, elapsing time
/// in [steps] equal increments until [expectedDelayMs] is reached,
/// at which point the callback is expected to have resolved.
void expectFakeDelay(
  Future Function() callback,
  int expectedDelayMs, [
  int steps = 4,
]) {
  return fakeAsync((async) {
    bool completed = false;
    final stepDelay = Duration(milliseconds: (expectedDelayMs / steps).ceil());

    callback().then((value) => completed = true);

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

    expect(
      completed,
      isTrue,
      reason: 'Completed time delay without completing future.',
    );
  });
}
