import 'dart:io';

import 'package:dio/dio.dart';

/// This handler ensures that mock data is saved and retrieved from the disk.
///
/// **NOTE**: [MockHandler] is currently, temporarily [Deprecated].
@deprecated
class MockHandler {
  /// Reads mock data file content located in [fullPath]
  /// as a string and returns [Future<ResponseBody>].
  Future<ResponseBody> readMock(String fullPath) async {
    return await File(fullPath).readAsString().then((String content) {
      return ResponseBody.fromString(content, HttpStatus.ok);
    });
  }

  /// Creates and writes the mock data inside
  /// a file located in [fullPath] as a JSON object [data].
  Future<ResponseBody> createMock(String fullPath, dynamic data) async {
    await File(fullPath)
        .create(recursive: true)
        .then((File file) => file.writeAsString(data));

    return readMock(fullPath);
  }
}
