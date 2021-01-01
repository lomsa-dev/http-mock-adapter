import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  test('regexp', () {
    expect(RegExpMatcher(regexp: RegExp(r'[0-9]')).matches('1'), true);
    expect(RegExpMatcher(regexp: RegExp(r'[a-z]')).matches('a'), true);
    expect(RegExpMatcher(regexp: RegExp(r'[a-z]+')).matches('abcdef'), true);
    expect(RegExpMatcher(regexp: RegExp(r'[a-z]+')).matches('abcdef '), true);
    expect(RegExpMatcher(regexp: RegExp(r'[a-z]+$')).matches('abcdef '), false);
    expect(RegExpMatcher(regexp: RegExp(r'a')).matches(1), false);
    expect(RegExpMatcher(regexp: RegExp(r'[0-9]')).matches(null), false);
    expect(RegExpMatcher(regexp: RegExp(r'[0-9]')).matches({}), false);
    expect(RegExpMatcher(regexp: RegExp(r'[0-9]')).matches([]), false);
    expect(RegExpMatcher(regexp: RegExp(r'[0-9]')).matches(Any()), false);
  });

  test('pattern', () {
    expect(RegExpMatcher(pattern: r'[0-9]').matches('1'), true);
    expect(RegExpMatcher(pattern: r'[a-z]').matches('a'), true);
    expect(
        RegExpMatcher(pattern: r'[a-z]+', caseSensitive: false)
            .matches('AbCdEf'),
        true);
    expect(RegExpMatcher(pattern: r'[a-z]+').matches('abcdef '), true);
    expect(RegExpMatcher(pattern: r'[a-z]+$').matches('abcdef '), false);
    expect(RegExpMatcher(pattern: r'a').matches(1), false);
    expect(RegExpMatcher(pattern: r'[0-9]').matches(null), false);
    expect(RegExpMatcher(pattern: r'[0-9]').matches({}), false);
    expect(RegExpMatcher(pattern: r'[0-9]').matches([]), false);
    expect(RegExpMatcher(pattern: r'[0-9]').matches(Any()), false);
  });
}
