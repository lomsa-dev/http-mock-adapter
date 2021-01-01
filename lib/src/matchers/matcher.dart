abstract class Matcher {
  bool matches(dynamic actual);
}

class Any extends Matcher {
  @override
  bool matches(dynamic actual) => true;

  @override
  String toString() => 'Any';
}

class AnyNumber extends Matcher {
  final bool strict; // require strict numbers or not, default false

  AnyNumber({this.strict = false});

  @override
  bool matches(dynamic actual) =>
      actual is int ||
      actual is double ||
      (!strict &&
          actual != null &&
          actual is String &&
          (int.tryParse(actual) is int || double.tryParse(actual) is double));

  @override
  String toString() => 'AnyNumber{strict: $strict}';
}

class RegExpMatcher extends Matcher {
  final RegExp regexp;

  RegExpMatcher({
    String pattern,
    bool multiline = false,
    bool caseSensitive = false,
    RegExp regexp,
  }) : regexp = regexp ??
            RegExp(
              pattern,
              multiLine: multiline,
              caseSensitive: caseSensitive,
            );

  @override
  bool matches(dynamic actual) =>
      actual != null && actual is String && regexp.hasMatch(actual);

  @override
  String toString() => 'RegExpMatcher{regexp: $regexp}';
}

final anyValue = Any();
final anyNumber = AnyNumber(); // defaults to not strict (will check strings)
