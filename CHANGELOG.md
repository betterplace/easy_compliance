# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.2] - 2021-11-01
### Fixed
- Fixed leaking `OpenSSL::OpenSSLErrors`, they are now wrapped

## [1.0.1] - 2021-10-25
### Fixed
- Removed `bin/console` and `bin/setup` from gem executables [#1]
