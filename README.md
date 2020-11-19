# http-mock-adapter

[![LICENSE](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/lomsa-dev/http-mock-adapter#License
"Project's LICENSE section")

## Description

HTTP mock adapter for Dart/Flutter (Compatible with Dio and Mockito).

---

## Usage

Here is the basic usage scenario of the package (via `DioAdapter`):

```dart
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() async {
  final dio = Dio();
  final dioAdapter = DioAdapter();

  dio.httpClientAdapter = dioAdapter;

  const path = 'https://example.com';

  dioAdapter
      .onGet(path)
      .reply(200, {'message': 'Successfully mocked GET!'})
      .onPost(path)
      .reply(200, {'message': 'Successfully mocked POST!'});

  final onGetResponse = await dio.get(path);
  print(onGetResponse.data); // {message: Successfully mocked GET!}

  final onPostResponse = await dio.post(path);
  print(onPostResponse.data); // {message: Successfully mocked POST!}
}
```

---

## Installing

**NOTICE**: Currently not available on <https://pub.dev>.

### Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  http_mock_adapter: ^0.0.1
```

### Install it

You can install packages from the command line:

with `pub`:

```sh
$ pub get
...
```

with `flutter`:

```sh
$ flutter pub get
...
```

Alternatively, your editor might support `pub get` or `flutter pub get`. Check the docs for your editor to learn more.

### Import it

Now in your Dart code, you can use:

```dart
import 'package:http_mock_adapter/http_mock_adapter.dart';
```

---

## Changelog

All notable changes to this project will be documented in the [CHANGELOG.md](https://github.com/lomsa-dev/http-mock-adapter/blob/master/CHANGELOG.md "Project's CHANGELOG.md file") file.

---

## Acknowledgements

**NOTICE**: The file doesn't exist for now.

See the
[ACKNOWLEDGEMENTS.md](https://github.com/lomsa-dev/http-mock-adapter/blob/master/ACKNOWLEDGEMENTS.md
"Project's ACKNOWLEDGEMENTS.md file") file for information regarding the
tools/resources used while developing the project.

---

## License

http-mock-adapter is licensed under the permissive MIT License ([LICENSE](https://github.com/lomsa-dev/http-mock-adapter/blob/master/LICENSE "Copy of the MIT license")).

---

## Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall be
dual licensed as above, without any additional terms or conditions.

For additional information regarding contributions, please refer to
[CONTRIBUTING.md](https://github.com/lomsa-dev/http-mock-adapter/blob/master/CONTRIBUTING.md "Project's CONTRIBUTING.md file") file.
