# Changelog

All notable changes to this project will be documented in this file.

Minor versions will be bundled with more important versions.

The format is influenced by [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Subsequently, the date entry follows **YYYY-MM-DD** format in accordance with the [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) standard.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v0.3.3] (2022-03-23)

- **Added**
  - `delay` property to `MockServer` methods: (reply & throws)
  - `HttpRequestMatcher` super class & its implementations `FullHttpRequestMatcher`, `UrlRequestMatcher`.
  -  Utilities file for tests.

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

[v0.3.2]: https://github.com/lomsa-dev/http-mock-adapter/compare/e1da999215a72378356b1b4883d32807091bf239...ac4991fb2c9808be44bd8165941bf7d9101de5bf
[v0.3.1]: https://github.com/lomsa-dev/http-mock-adapter/compare/e1da999215a72378356b1b4883d32807091bf239...70fb7802f0ad48e03abb16a7197b933b1306c332
[v0.3.0]: https://github.com/lomsa-dev/http-mock-adapter/compare/70fb7802f0ad48e03abb16a7197b933b1306c332...f138e738dea358a386537adfb9df3e1c5dc79c0c
[v0.2.1]: https://github.com/lomsa-dev/http-mock-adapter/compare/f138e738dea358a386537adfb9df3e1c5dc79c0c...ec13a0f1ca3cb0fd56620832a79db5ab04ad8742
[v0.2.0]: https://github.com/lomsa-dev/http-mock-adapter/compare/24cafff5236f8cc7d52a05529751ac47abd895ff...f138e738dea358a386537adfb9df3e1c5dc79c0c
[v0.1.6]: https://github.com/lomsa-dev/http-mock-adapter/compare/ff0b5b1c9d976e774002f3176fa0b6acd193c715...24cafff5236f8cc7d52a05529751ac47abd895ff
[v0.1.5]: https://github.com/lomsa-dev/http-mock-adapter/compare/19310519550fc6402eb760ee5f3ef0757d187b89...ff0b5b1c9d976e774002f3176fa0b6acd193c715
[v0.1.4]: https://github.com/lomsa-dev/http-mock-adapter/compare/21f5d211b8a798206fe4a727bff3a60eb8e3dcaf...19310519550fc6402eb760ee5f3ef0757d187b89
[v0.1.3]: https://github.com/lomsa-dev/http-mock-adapter/compare/c0ab40ed59d3898ebf03d706b25ca8b91c2d065d...21f5d211b8a798206fe4a727bff3a60eb8e3dcaf
[v0.1.2]: https://github.com/lomsa-dev/http-mock-adapter/compare/87c41f1758660b94efc1538de39fb04bb12c0b95...c0ab40ed59d3898ebf03d706b25ca8b91c2d065d
[v0.1.1]: https://github.com/lomsa-dev/http-mock-adapter/compare/c3da8b18fb583cac0500f9899c4901f40fdf18e5...87c41f1758660b94efc1538de39fb04bb12c0b95
[v0.1.0]: https://github.com/lomsa-dev/http-mock-adapter/compare/7d3ffbf4f85ae69327b1736f9268df24607d7ccb...c3da8b18fb583cac0500f9899c4901f40fdf18e5
[v0.0.1]: https://github.com/lomsa-dev/http-mock-adapter/compare/447829b2969300e0ff7e9d6a7c6697cd5744b632...7d3ffbf4f85ae69327b1736f9268df24607d7ccb
