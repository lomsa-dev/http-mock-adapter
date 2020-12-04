# Changelog

All notable changes to this project will be documented in this file.

Minor versions will be bundled with more important versions.

The format is influenced by [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Subsequently, the date entry follows **YYYY-MM-DD** format in accordance with the [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) standard.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v0.1.3] (2020-12-4)

- **Updated**
  - Update package's documentation

  - Update request handling through headers

---

## [v0.1.2] (2020-11-26)

- **Updated**
  - Improved GitHub Actions workflow upon each version update on each push made to `main` branch

---

## [v0.1.1] (2020-11-23)

- **Added**
  - Author metadata
  - Automatic publishing on <https://pub.dev> through GitHub Actions

- **Updated**
  - Routing logic
  - Package ocumentation

---

## [v0.1.0] (2020-11-20)

- **Added**
  - History mixin to keep track of request history
  - HTTP methods
  - RequestRouted - exposes developer-friendly methods which take in routes
  - RequestHandler - The handler of requests sent by clients
  - DioAdapter without mockito
  - Mocked version of DioAdapter
  - Tast cases
  - Non-sequential responding

- **Removed**
  - MockHandler - temporarily deprecated (ensures that mock data is saved and retrieved from the disk)

---

## [v0.0.1] (2020-11-09)

- **Added**
  - The MIT License

[v0.1.3]: https://github.com/lomsa-dev/http-mock-adapter/compare/c0ab40ed59d3898ebf03d706b25ca8b91c2d065d...a577c79060e8dbe33a2b768d7c675a9498a00d29
[v0.1.2]: https://github.com/lomsa-dev/http-mock-adapter/compare/87c41f1758660b94efc1538de39fb04bb12c0b95...c0ab40ed59d3898ebf03d706b25ca8b91c2d065d
[v0.1.1]: https://github.com/lomsa-dev/http-mock-adapter/compare/c3da8b18fb583cac0500f9899c4901f40fdf18e5...87c41f1758660b94efc1538de39fb04bb12c0b95
[v0.1.0]: https://github.com/lomsa-dev/http-mock-adapter/compare/7d3ffbf4f85ae69327b1736f9268df24607d7ccb...c3da8b18fb583cac0500f9899c4901f40fdf18e5
[v0.0.1]: https://github.com/lomsa-dev/http-mock-adapter/compare/447829b2969300e0ff7e9d6a7c6697cd5744b632...7d3ffbf4f85ae69327b1736f9268df24607d7ccb
