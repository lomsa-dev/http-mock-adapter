# http-mock-adapter

[![LICENSE](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/lomsa-dev/http-mock-adapter#License
"Project's LICENSE section")

## Description

HTTP mock adapter for Dart/Flutter (compatible with Dio and Mockito).

Sometimes, testing classes which are dependent on [Dio](https://pub.dev/packages/dio) requests are really tricky and require lots of boilerplate, this is where [http_mock_adapter](https://pub.dev/packages/http_mock_adapter) comes in, to make [Dio](https://pub.dev/packages/dio) request testing more flexible than it has ever been. By simply defining requests with their methods and responses by using chains of our [DioAdapter](https://pub.dev/documentation/http_mock_adapter/latest/http_mock_adapter/DioAdapter-class.html) and replacing [Dio](https://pub.dev/packages/dio)'s [httpClientAdapter](https://pub.dev/documentation/dio/latest/dio/HttpClientAdapter-class.html) with your custom mocked adapter, you will be able to mock basically any request that [Dio](https://pub.dev/packages/dio) can support. More over, [http_mock_adapter](https://pub.dev/packages/http_mock_adapter) package, supports request mocking with interceptors which are created via DioInterceptor class, so instead of replacing [Dio](https://pub.dev/packages/dio)'s [httpClientAdapter](https://pub.dev/documentation/dio/latest/dio/HttpClientAdapter-class.html) you can add your mocked interceptor inside the [dio.interceptors](https://pub.dev/documentation/dio/latest/dio/Interceptors-class.html) list by using its [add method](https://api.dart.dev/dev/2.12.0-29.0.dev/dart-collection/ListMixin/add.html). you can find example in [examples](https://pub.dev/packages/http_mock_adapter/example) section of [http_mock_adapter](https://pub.dev/packages/http_mock_adapter) package.

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

### Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dev_dependencies:
  http_mock_adapter: ^0.1.0
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

## Authors

See the [AUTHORS](https://github.com/lomsa-dev/http-mock-adapter/blob/master/AUTHORS "Project's AUTHORS file") file for information regarding the authors of the project.

---

## License

http-mock-adapter is licensed under the permissive MIT License ([LICENSE](https://github.com/lomsa-dev/http-mock-adapter/blob/master/LICENSE "Copy of the MIT license")).

---

## Contribution

For information regarding contributions, please refer to [CONTRIBUTING.md](https://github.com/lomsa-dev/http-mock-adapter/blob/master/CONTRIBUTING.md "Project's CONTRIBUTING.md file") file.
