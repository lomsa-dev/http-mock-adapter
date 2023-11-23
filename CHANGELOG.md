# Changelog

All notable changes to this project will be documented in this file.

Minor versions will be bundled with more important versions.

The format is influenced by [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Subsequently, the date entry follows **YYYY-MM-DD** format in accordance with the [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) standard.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.6.1] (2023-05-03)

- **Fixed**
  - Fix: Library not compatible with flutter 3.16.0 - incorrect type definition

## [v0.6.0] (2023-08-30)

- **Add**
  - [#136](https://github.com/lomsa-dev/http-mock-adapter/issues/136): Next interceptor handler on DioInterceptor for missing mocks
  - [#149](https://github.com/lomsa-dev/http-mock-adapter/issues/149): Exact body check option for FullHttpRequestMatcher
  - [#153](https://github.com/lomsa-dev/http-mock-adapter/issues/153) [#156](https://github.com/lomsa-dev/http-mock-adapter/issues/156): (async)callback
- **Fixed**
  - [#160](https://github.com/lomsa-dev/http-mock-adapter/issues/160): Downgrade collection to 1.17.1 due to incompability;

Special thanks to [sebastianbuechler](https://github.com/sebastianbuechler)

## [v0.5.0] (2023-05-03)

- **Updated**
  - Bump up sdk and dependency versions:
    - sdk: >=3.0.0
    - collection: ^1.18.0
    - dio: ^5.3.2

## [v0.4.4] (2023-05-03)

- **Updated**
  - Fix: remove unused import dart:ffi

## [v0.4.3] (2023-05-01)

- **Add**
  - Response like Protocol Buffer will have byte response body. Add support for mock response of byte data.
  - unit tests for RequestHandler class. #146

## [v0.4.2] (2023-02-15)

- **Updated**
  - Downgrade dependency constraints to match minimum `dio` requirements

## [v0.4.1] (2023-02-15)

- **Updated**
  - Downgrade collection to 1.15.0 due to incompability (issue [#141](https://github.com/lomsa-dev/http-mock-adapter/issues/141))
  - Update package homepage

## [v0.4.0] (2023-02-14)

- **Updated**

  - Dio dependency to `5.0.0`
  - Github Workflow (release on tag)
  - Codecov token
  - Collection to 1.17.1

- **Removed**
  - Recursive export of matchers.dart
  - Unnecessary ListParam

## [v0.3.3] (2022-03-23)

- **Added**

  - `delay` property to `MockServer` methods: (reply & throws)
  - `HttpRequestMatcher` super class & its implementations `FullHttpRequestMatcher`, `UrlRequestMatcher`.
  - Utilities file for tests.

- **Updated**
  - Docs in `README.md` and `example/main.dart`.
  - Tests for `DioAdapter`.

## [v0.3.2] (2021-07-26)

- **Added**

  - Automatic wrapping of `FormData` in a fitting matcher.

- **Fixed**

  - Missing expectation in map not causing test failures.

- **Removed**

  - Header matcher.

- **Updated**
  - Tests for `DioAdapter` and `DioInterceptor` by combining them.

## [v0.3.1] (2021-06-16)

- **Removed**

  - Unused import and code regarding `io_adapter` that reduced the overall score of the package.

- **Updated**
  - `pub` badge link in `README.md`.

## [v0.3.0] (2021-06-16)

- **Added**

  - Remaining tests for formal 100% coverage;
  - Code coverage badge;
  - New, official Dart linter (`lints`) and some custom rules;
  - Constructors to `DioAdapter` and `DioInterceptor`;
  - `ClosedException`, thrown when `DioAdapter` is closed yet used;
  - Builder method for `Signature` extension.

- **Removed**

  - Unused package and code, such as `mockito` and/or `DioAdapterMockito`;
  - Some portion of seemingly excessive documentation;
  - Generally unnecessary pieces of code.

- **Updated**
  - Tests and lots of files due to refactoring;
  - Packages;
  - Names of types, methods and variables for better clarity.

## [v0.2.1] (2021-04-02)

- **Removed**

  - Unused and artificially deprecated code.

- **Updated**
  - CI workflow;
  - Packages.

## [v0.2.0] (2021-04-02)

- **Added**
  - Null safety.

## [v0.1.6] (2021-03-30)

- **Added**

  - Ability to match routes based on pattern;
  - Tests;
  - Straightforward way to reset history;
  - Query parameters to `RequestRouted`'s methods.

- **Fixed**

  - `Response` problems regarding closed streams.

- **Removed**

  - Singleton instances of `DioAdapter` and `DioInterceptor`;

- **Updated**
  - `Match` variable names;
  - `matches` function to include null check;
  - `.gitignore` now includes `pubspec.lock`;
  - Request mock method chaining variation.

---

## [v0.1.5] (2021-01-07)

- **Added**

  - `Matchers` class that contains various types of request data matchers for dynamic signature matching;
  - `Dart CI` workflow;
  - `git` tags for untagged releases/publications;
  - Specific imports by utilizing `Dart`'s `show` keyword.

- **Removed**

  - Unnecessary `node_modules/` directory with its content;
  - Unnecessary `workflows/` directory with its content in `.github/ISSUE_TEMPLATE/` directory;
  - Unnecessary `package-lock.json` file;
  - Unnecessary `.metadata` file.

- **Updated**
  - Issue templates;
  - Pull request template;
  - `example/main.dart` code;
  - Source code formatting/style;
  - Source code documentation;
  - License's `Copyright (c)` year;
  - `http` and `test` `dev_dependencies`' version;
  - Header setting logic for both request and response (Defaults to JSON and matches any `Headers.contentTypeLength`);
  - Project's meta files;
  - Tests by relocating, reformatting, organizing them.

---

## [v0.1.4] (2020-12-28)

- **Added**

  - `throws` method to test `Dio` exceptions.

- **Fixed**

  - `Signature` related bug.

- **Updated**
  - Package architecture.

---

## [v0.1.3] (2020-12-4)

- **Updated**
  - Package's documentation;
  - Request handling through headers.

---

## [v0.1.2] (2020-11-26)

- **Updated**
  - `GitHub Actions` workflow upon each version update on each push made to `main` branch.

---

## [v0.1.1] (2020-11-23)

- **Added**

  - Author metadata;
  - Automatic publishing on <https://pub.dev> through `GitHub Actions`.

- **Updated**
  - Routing logic;
  - Package documentation.

---

## [v0.1.0] (2020-11-20)

- **Added**

  - `History` mixin to keep track of request history;
  - HTTP methods;
  - `RequestRouted` - exposes developer-friendly methods which take in routes;
  - `RequestHandler` - The handler of requests sent by clients;
  - `DioAdapter` without mockito;
  - Mocked version of `DioAdapter`;
  - Tast cases;
  - Non-sequential responding.

- **Removed**
  - `MockHandler` - Temporarily deprecated (ensures that mock data is saved and retrieved from the disk).

---

## [v0.0.1] (2020-11-09)

- **Added**
  - The MIT License.
