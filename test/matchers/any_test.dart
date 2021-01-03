import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  const anyMatcher = Matchers.any;

  group('AnyMatcher', () {
    test('matches correctly', () {
      expect(anyMatcher.matches('a'), true);
      expect(anyMatcher.matches(null), true);
      expect(anyMatcher.matches(1), true);
      expect(anyMatcher.matches({}), true);
      expect(anyMatcher.matches([]), true);
    });
  });
}
