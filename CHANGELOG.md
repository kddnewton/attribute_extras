# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2018-12-05

### Changed

- Instead of overwriting the writer, adds a `before_validation` callback so that the extras can be composed.
- From `set_*_attributes` to just `*_attributes`, .e.g, `set_nullified_attributes` became `nullify_attributes`.

### Removed

- All of the introspection methods.

[Unreleased]: https://github.com/kddnewton/attribute_extras/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/kddnewton/attribute_extras/compare/ccda61...v1.0.0
