import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  const stringMatcher = Matchers.string;

  group('StringMatcher', () {
    test('matches correctly', () {
      expect(stringMatcher.matches('a'), true);
      expect(stringMatcher.matches(''), true);
      expect(stringMatcher.matches(null), false);
      expect(stringMatcher.matches(1), false);
      expect(stringMatcher.matches({}), false);
      expect(stringMatcher.matches([]), false);
    });
  });
}
