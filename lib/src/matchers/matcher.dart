/// An abstract class that has a single method [matches], which
/// takes in data and determines if pre-defined matching occurs.
abstract class Matcher {
  const Matcher();

  /// Determines if pre-defined matching occurs based on [actual].
  bool matches(dynamic actual);
}
