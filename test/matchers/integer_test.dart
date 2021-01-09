import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  const integerMatcher = Matchers.integer;
  final strictIntegerMatcher = Matchers.strict.integer;

  group('IntegerMatcher', () {
    test('from default constructor values matches correctly', () {
      expect(integerMatcher.matches(1), true);
      expect(integerMatcher.matches('1'), true);
      expect(integerMatcher.matches('1.12'), false);
      expect(integerMatcher.matches(1.0), false);
      expect(integerMatcher.matches('a'), false);
      expect(integerMatcher.matches(null), false);
      expect(integerMatcher.matches({}), false);
      expect(integerMatcher.matches([]), false);
    });

    test('from strict constructor values matches correctly', () {
      expect(strictIntegerMatcher.matches(1), true);
      expect(strictIntegerMatcher.matches('1'), false);
      expect(strictIntegerMatcher.matches('1.12'), false);
      expect(strictIntegerMatcher.matches(1.0), false);
      expect(strictIntegerMatcher.matches('a'), false);
      expect(strictIntegerMatcher.matches(null), false);
      expect(strictIntegerMatcher.matches({}), false);
      expect(strictIntegerMatcher.matches([]), false);
    });
  });
}
