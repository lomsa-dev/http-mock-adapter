import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  const booleanMatcher = Matchers.boolean;
  final strictBooleanMatcher = Matchers.strict.boolean;

  group('BooleanMatcher', () {
    test('from default constructor values matches correctly', () {
      expect(booleanMatcher.matches(true), true);
      expect(booleanMatcher.matches('true'), true);
      expect(booleanMatcher.matches('TRuE'), true);
      expect(booleanMatcher.matches(false), true);
      expect(booleanMatcher.matches('false'), true);
      expect(booleanMatcher.matches('FaLsE'), true);
      expect(booleanMatcher.matches(1), false);
      expect(booleanMatcher.matches('2'), false);
      expect(booleanMatcher.matches('boolean'), false);
      expect(booleanMatcher.matches(null), false);
      expect(booleanMatcher.matches({}), false);
      expect(booleanMatcher.matches([]), false);
    });

    test('from strict constructor values matches correctly', () {
      expect(strictBooleanMatcher.matches(true), true);
      expect(strictBooleanMatcher.matches('true'), false);
      expect(strictBooleanMatcher.matches('TRuE'), false);
      expect(strictBooleanMatcher.matches(false), true);
      expect(strictBooleanMatcher.matches('false'), false);
      expect(strictBooleanMatcher.matches('FaLsE'), false);
      expect(strictBooleanMatcher.matches(1), false);
      expect(strictBooleanMatcher.matches('2'), false);
      expect(strictBooleanMatcher.matches('boolean'), false);
      expect(strictBooleanMatcher.matches(null), false);
      expect(strictBooleanMatcher.matches({}), false);
      expect(strictBooleanMatcher.matches([]), false);
    });
  });
}
