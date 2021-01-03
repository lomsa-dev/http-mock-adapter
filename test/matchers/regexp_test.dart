import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  group('RegExpMatcher', () {
    test('from pre-defined RegExp instance matches correctly', () {
      expect(RegExpMatcher(regExp: RegExp(r'[0-9]')).matches('1'), true);
      expect(RegExpMatcher(regExp: RegExp(r'[a-z]')).matches('a'), true);
      expect(RegExpMatcher(regExp: RegExp(r'[a-z]+')).matches('abcdef'), true);
      expect(RegExpMatcher(regExp: RegExp(r'[a-z]+')).matches('abcdef '), true);
      expect(
        RegExpMatcher(regExp: RegExp(r'[a-z]+$')).matches('abcdef '),
        false,
      );
      expect(RegExpMatcher(regExp: RegExp(r'a')).matches(1), false);
      expect(RegExpMatcher(regExp: RegExp(r'[0-9]')).matches(null), false);
      expect(RegExpMatcher(regExp: RegExp(r'[0-9]')).matches({}), false);
      expect(RegExpMatcher(regExp: RegExp(r'[0-9]')).matches([]), false);
      expect(RegExpMatcher(regExp: RegExp(r'[0-9]')).matches(Any()), false);
    });

    test('from pre-defined pattern value matches correctly', () {
      expect(RegExpMatcher(pattern: r'[0-9]').matches('1'), true);
      expect(RegExpMatcher(pattern: r'[a-z]').matches('a'), true);
      expect(
        RegExpMatcher(
          pattern: r'[a-z]+',
          caseSensitive: false,
        ).matches('AbCdEf'),
        true,
      );
      expect(RegExpMatcher(pattern: r'[a-z]+').matches('abcdef '), true);
      expect(RegExpMatcher(pattern: r'[a-z]+$').matches('abcdef '), false);
      expect(RegExpMatcher(pattern: r'a').matches(1), false);
      expect(RegExpMatcher(pattern: r'[0-9]').matches(null), false);
      expect(RegExpMatcher(pattern: r'[0-9]').matches({}), false);
      expect(RegExpMatcher(pattern: r'[0-9]').matches([]), false);
      expect(RegExpMatcher(pattern: r'[0-9]').matches(Any()), false);
    });
  });
}
