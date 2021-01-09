import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  const numberMatcher = Matchers.number;
  final strictNumberMatcher = Matchers.strict.number;

  group('NumberMatcher', () {
    test('from default constructor values matches correctly', () {
      expect(numberMatcher.matches(1), true);
      expect(numberMatcher.matches('1'), true);
      expect(numberMatcher.matches('a'), false);
      expect(numberMatcher.matches(null), false);
      expect(numberMatcher.matches({}), false);
      expect(numberMatcher.matches([]), false);
    });

    test('from strict constructor values matches correctly', () {
      expect(strictNumberMatcher.matches(1), true);
      expect(strictNumberMatcher.matches('1'), false);
      expect(strictNumberMatcher.matches('a'), false);
      expect(strictNumberMatcher.matches(null), false);
      expect(strictNumberMatcher.matches({}), false);
      expect(strictNumberMatcher.matches([]), false);
    });
  });
}
