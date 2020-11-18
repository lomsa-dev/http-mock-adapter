import 'dart:io';

/// [PathParser] is a function-type alias intended to match
/// path parsing function signatures.
typedef PathParser = String Function(String path);

/// Gets mock data's file name after modifying the user-specified [path].
///
/// ## Example with leading forward slash:
/// ```dart
/// getMockFileName('/route') == '-route'
/// ```
/// ## Example with full URL:
/// ```dart
/// getMockFileName('https://example.com') == '-example'
/// ```
/// ## Example with full URL including a subdomain and a route:
/// ```dart
/// getMockFileName('https://api.example.com/route') == '-example'
/// ```
String getMockFileName(String path) => _parsePathToMockFileName(path);

/// Parses path into a mock file name. Utilized by [getMockFileName].
String _parsePathToMockFileName(String path) {
  /// Matches routes or domains.
  final domainMatcher = RegExp(r'.+\/\/|www.|\..+');

  /// Function that empties all of the [domainMatcher] matches.
  // ignore: omit_local_variable_types
  PathParser parse = ((String path) => path.replaceAll(domainMatcher, ''));

  /// Parses the path into a mock file name. If the length is greater than 2,
  /// it means that more than two dots are used in the URL, which is not ideal,
  /// thus, we cut only the domain part and run it through [parse].
  final mockFileName = '.'.allMatches(path).length >= 2
      ? parse(path.split('.')[1])
      : parse(path);

  /// Checks if the mock file name has a leading forward slash.
  /// If found, discards it and returns [mockFileName] with a leading dash.
  return mockFileName.startsWith('/')
      ? '-${mockFileName.substring(1)}'
      : '-$mockFileName';
}

/// Gets the path of the root (working) directory.
///
/// Checks to see if [Directory]'s path ends with 'test' in order to return
/// the parent path where `assets/` directory has more reason to exist in.
String getRootDirectoryPath() => Directory.current.path.endsWith('test')
    ? Directory.current.parent.path
    : Directory.current.path;
