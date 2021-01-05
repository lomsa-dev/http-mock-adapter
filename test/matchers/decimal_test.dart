import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  const decimalMatcher = Matchers.decimal;
  final strictDecimalMatcher = Matchers.strict.decimal;

  group('DecimalMatcher', () {
    test('from default constructor values matches correctly', () {
      expect(decimalMatcher.matches(1.0), true);
      expect(decimalMatcher.matches('1'), true);
      expect(decimalMatcher.matches('1.12'), true);
      expect(decimalMatcher.matches(1), false);
      expect(decimalMatcher.matches('a'), false);
      expect(decimalMatcher.matches(null), false);
      expect(decimalMatcher.matches({}), false);
      expect(decimalMatcher.matches([]), false);
    });

    test('from strict constructor values matches correctly', () {
      expect(strictDecimalMatcher.matches(1.0), true);
      expect(strictDecimalMatcher.matches('1'), false);
      expect(strictDecimalMatcher.matches('1.12'), false);
      expect(strictDecimalMatcher.matches(1), false);
      expect(strictDecimalMatcher.matches('a'), false);
      expect(strictDecimalMatcher.matches(null), false);
      expect(strictDecimalMatcher.matches({}), false);
      expect(strictDecimalMatcher.matches([]), false);
    });
  });
}
