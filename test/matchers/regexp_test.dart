import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  group('RegExpMatcher', () {
    test('from pre-defined RegExp instance matches correctly', () {
      expect(Matchers.regExp(RegExp(r'[0-9]')).matches('1'), true);
      expect(Matchers.regExp(RegExp(r'[a-z]')).matches('a'), true);
      expect(Matchers.regExp(RegExp(r'[a-z]+')).matches('abcdef'), true);
      expect(Matchers.regExp(RegExp(r'[a-z]+')).matches('abcdef '), true);
      expect(Matchers.regExp(RegExp(r'[a-z]+$')).matches('abcdef '), false);
      expect(Matchers.regExp(RegExp(r'a')).matches(1), false);
      expect(Matchers.regExp(RegExp(r'[0-9]')).matches(null), false);
      expect(Matchers.regExp(RegExp(r'[0-9]')).matches({}), false);
      expect(Matchers.regExp(RegExp(r'[0-9]')).matches([]), false);
    });

    test('from pre-defined pattern value matches correctly', () {
      expect(Matchers.pattern(r'[0-9]').matches('1'), true);
      expect(Matchers.pattern(r'[a-z]').matches('a'), true);
      expect(
          Matchers.pattern(
            r'[a-z]+',
            caseSensitive: false,
          ).matches('AbCdEf'),
          true);
      expect(Matchers.pattern(r'[a-z]+').matches('abcdef '), true);
      expect(Matchers.pattern(r'[a-z]+$').matches('abcdef '), false);
      expect(Matchers.pattern(r'a').matches(1), false);
      expect(Matchers.pattern(r'[0-9]').matches(null), false);
      expect(Matchers.pattern(r'[0-9]').matches({}), false);
      expect(Matchers.pattern(r'[0-9]').matches([]), false);
    });
  });
}
