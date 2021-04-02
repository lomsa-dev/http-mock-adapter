import 'package:http_mock_adapter/src/matchers/matcher.dart';

/// Subclass of [Matcher] that only returns true upon calling [matches]
/// if provided a non-null [String] that is matched by [regExp].
class RegExpMatcher extends Matcher {
  /// [regExp] is used by [matches] in form of calling [regExp.hasMatch(input)].
  final RegExp regExp;

  RegExpMatcher({
    String? pattern,
    bool multiLine = false,
    bool caseSensitive = false,
    RegExp? regExp,
  }) : regExp = regExp ??
            RegExp(
              pattern!,
              multiLine: multiLine,
              caseSensitive: caseSensitive,
            );

  @override
  bool matches(dynamic actual) =>
      actual != null && actual is String && regExp.hasMatch(actual);

  @override
  String toString() => 'RegExpMatcher { regexp: $regExp }';
}
