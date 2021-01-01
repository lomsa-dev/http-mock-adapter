import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  var strict = AnyNumber(strict: true);
  var notStrict = AnyNumber();

  test('anyNumber not-strict', () {
    expect(anyNumber.matches(1), true);
    expect(anyNumber.matches('1'), true);
    expect(anyNumber.matches('a'), false);
    expect(anyNumber.matches(null), false);
    expect(anyNumber.matches({}), false);
    expect(anyNumber.matches([]), false);
    expect(anyNumber.matches(Any()), false);
  });

  test('not strict', () {
    expect(notStrict.matches(1), true);
    expect(notStrict.matches('1'), true);
    expect(notStrict.matches('a'), false);
    expect(notStrict.matches(null), false);
    expect(notStrict.matches({}), false);
    expect(notStrict.matches([]), false);
    expect(notStrict.matches(Any()), false);
  });

  test('strict', () {
    expect(strict.matches(1), true);
    expect(strict.matches('1'), false);
    expect(strict.matches('a'), false);
    expect(strict.matches(null), false);
    expect(strict.matches({}), false);
    expect(strict.matches([]), false);
    expect(strict.matches(Any()), false);
  });
}
