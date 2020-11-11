import 'dart:io';

/// Gets mock data's file name after modifying the user-specified [uriPath].
///
/// ## Example:
/// ```dart
/// getMockFileName('/route') == '-route'
/// ```
String getMockFileName(String uriPath) {
  {
    final mockFileName = uriPath.replaceAll(RegExp(r'/'), '-');

    return uriPath.startsWith('/') ? mockFileName : '-$mockFileName';
  }
}

/// Gets the path of the root (working) directory.
///
/// Checks to see if [Directory]'s path ends with 'test' in order to return
/// the parent path where `assets/` directory has more reason to exist in.
String getRootDirectoryPath() => Directory.current.path.endsWith('test')
    ? Directory.current.parent.path
    : Directory.current.path;
