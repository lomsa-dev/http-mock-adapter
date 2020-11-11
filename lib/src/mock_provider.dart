import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

mixin MockProvider {
  Future<ResponseBody> readMock(String fullPath) async {
    return await File(fullPath).readAsString().then((String content) {
      return ResponseBody.fromString(content, HttpStatus.ok);
    });
  }

  Future<ResponseBody> createMock(String fullPath, dynamic data) async {
    await File(fullPath).create(recursive: true).then(
          (File file) => file.writeAsString(
            jsonEncode(
              data,
            ),
          ),
        );

    return readMock(fullPath);
  }
}
