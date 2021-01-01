import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  test('anyValue default', () {
    expect(anyValue.matches('a'), true);
    expect(anyValue.matches(null), true);
    expect(anyValue.matches(1), true);
    expect(anyValue.matches({}), true);
    expect(anyValue.matches([]), true);
    expect(anyValue.matches(Any()), true);
  });

  test('any value', () {
    expect(Any().matches('a'), true);
    expect(Any().matches(null), true);
    expect(Any().matches(1), true);
    expect(Any().matches({}), true);
    expect(Any().matches([]), true);
    expect(Any().matches(Any()), true);
  });
}
