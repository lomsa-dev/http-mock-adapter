import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

/// This handler ensures that mock data is saved and retrieved from the disk.
class MockHandler {
  /// Reads mock data file contents as string and returns response body.
  Future<ResponseBody> readMock(String fullPath) async {
    return await File(fullPath).readAsString().then((String content) {
      return ResponseBody.fromString(content, HttpStatus.ok);
    });
  }

  /// Creates and writes the mock data inside a file as a JSON object.
  Future<ResponseBody> createMock(String fullPath, dynamic data) async {
    await File(fullPath)
        .create(recursive: true)
        .then((File file) => file.writeAsString(jsonEncode(data)));

    return readMock(fullPath);
  }
}
