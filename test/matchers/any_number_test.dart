import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  const strict = AnyNumber(strict: true);
  const notStrict = AnyNumber();

  group('AnyNumber', () {
    test('from default constructor values matches correctly', () {
      expect(anyNumber.matches(1), true);
      expect(anyNumber.matches('1'), true);
      expect(anyNumber.matches('a'), false);
      expect(anyNumber.matches(null), false);
      expect(anyNumber.matches({}), false);
      expect(anyNumber.matches([]), false);
      expect(anyNumber.matches(Any()), false);
    });

    test('from not strict constructor values matches correctly', () {
      expect(notStrict.matches(1), true);
      expect(notStrict.matches('1'), true);
      expect(notStrict.matches('a'), false);
      expect(notStrict.matches(null), false);
      expect(notStrict.matches({}), false);
      expect(notStrict.matches([]), false);
      expect(notStrict.matches(Any()), false);
    });

    test('from strict constructor values matches correctly', () {
      expect(strict.matches(1), true);
      expect(strict.matches('1'), false);
      expect(strict.matches('a'), false);
      expect(strict.matches(null), false);
      expect(strict.matches({}), false);
      expect(strict.matches([]), false);
      expect(strict.matches(Any()), false);
    });
  });
}
