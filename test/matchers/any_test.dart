import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  group('Any', () {
    test('from default constructor values matches correctly', () {
      expect(anyValue.matches('a'), true);
      expect(anyValue.matches(null), true);
      expect(anyValue.matches(1), true);
      expect(anyValue.matches({}), true);
      expect(anyValue.matches([]), true);
      expect(anyValue.matches(Any()), true);
    });

    test('from in-place default constructor values matches correctly', () {
      expect(const Any().matches('a'), true);
      expect(const Any().matches(null), true);
      expect(const Any().matches(1), true);
      expect(const Any().matches({}), true);
      expect(const Any().matches([]), true);
      expect(const Any().matches(Any()), true);
    });
  });
}
