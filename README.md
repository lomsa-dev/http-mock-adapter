# http-mock-adapter

[![Package Version](https://img.shields.io/pub/v/http_mock_adapter?color=teal)](https://pub.dev/packages/http_mock_adapter "Published package version")
[![Style: Lints](https://img.shields.io/badge/style-lints-teal.svg)](https://github.com/dart-lang/lints "Package linter helper")
[![Dart CI](https://github.com/lomsa-dev/http-mock-adapter/workflows/Dart%20CI/badge.svg?branch=develop)](https://github.com/lomsa-dev/http-mock-adapter/actions?query=workflow%3A%22Dart+CI%22 "Dart CI workflow")
[![Publish Package](https://github.com/lomsa-dev/http-mock-adapter/workflows/Publish%20Package/badge.svg?branch=main)](https://github.com/lomsa-dev/http-mock-adapter/actions?query=workflow%3A%22Publish+Package%22 "Publish Package workflow")
[![LICENSE](https://img.shields.io/badge/License-MIT-red.svg)](https://github.com/lomsa-dev/http-mock-adapter#License "Project's LICENSE section")
[![codecov](https://codecov.io/gh/lomsa-dev/http-mock-adapter/branch/main/graph/badge.svg?token=7H1HPCGFJ6)](https://codecov.io/gh/lomsa-dev/http-mock-adapter)

## Description

`http_mock_adapter` is a simple to use mocking package for [Dio](https://pub.dev/packages/dio) intended to be used in tests. It provides various types and methods to declaratively mock request-response communication.

## Usage

Here is a very basic usage scenario:

```dart
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() async {
  final dio = Dio(BaseOptions());
  final dioAdapter = DioAdapter(dio: dio);

  const path = 'https://example.com';

  dioAdapter.onGet(
    path,
    (server) => server.reply(
      200,
      {'message': 'Success!'},
      // Reply would wait for one-sec before returning data.
      delay: const Duration(seconds: 1),
    ),
  );

  final response = await dio.get(path);

  print(response.data); // {message: Success!}
}
```

### Real-world example

The intended usage domain is in tests when trying to simulate behavior of request-response communication with a server. The [example](https://github.com/lomsa-dev/http-mock-adapter/blob/main/example/main.dart) portrays a decent use case of how one might make good use of the package.

## Installing

### Quick install

You can quickly install the package from the command-line:

With `dart`:

```sh
$ dart pub add --dev http_mock_adapter
...
```

With `flutter`:

```sh
$ flutter pub add --dev http_mock_adapter
...
```

### Manual install

#### Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dev_dependencies:
  http_mock_adapter: ^0.3.3
```

#### Install it

You can then install the package from the command-line:

With `dart`:

```sh
$ dart pub get
...
```

With `flutter`:

```sh
$ flutter pub get
...
```

Alternatively, your editor might support `dart pub get` or `flutter pub get`. Check the docs for your editor to learn more.

### Import it

Now in your Dart code, you can use:

```dart
import 'package:http_mock_adapter/http_mock_adapter.dart';
```

## Changelog

All notable changes to this project will be documented in the [CHANGELOG.md](https://github.com/lomsa-dev/http-mock-adapter/blob/main/CHANGELOG.md "Project's CHANGELOG.md file") file.

## Authors

See the [AUTHORS](https://github.com/lomsa-dev/http-mock-adapter/blob/main/AUTHORS "Project's AUTHORS file") file for information regarding the authors of the project.

## License

http-mock-adapter is licensed under the permissive MIT License ([LICENSE](https://github.com/lomsa-dev/http-mock-adapter/blob/main/LICENSE "Copy of the MIT license")).

## Contribution

For information regarding contributions, please refer to [CONTRIBUTING.md](https://github.com/lomsa-dev/http-mock-adapter/blob/main/CONTRIBUTING.md "Project's CONTRIBUTING.md file") file.
