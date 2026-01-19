# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-01-20

### Added
- Initial release of DDD Value Objects package
- **EmailAddress** Value Object with RFC 5322 validation
    - Email normalization (lowercase, trim)
    - Domain and local part extraction
    - Comprehensive validation
- **Password** Value Object with configurable validation
    - Three preset configurations (strong, medium, weak)
    - Custom configuration support
    - Password strength calculation (0-100 scale)
    - Character requirement checks (uppercase, lowercase, digit, special)
- **Name** Value Objects (FirstName, LastName, FullName)
    - Automatic capitalization (FirstName: "Jean", LastName: "DUPONT")
    - Support for international characters (accents, etc.)
    - Support for hyphens and apostrophes
    - FullName creation from string or parts
- **Age** Value Object with customizable constraints
    - Default range: 0-150 years
    - Custom min/max age support
    - Helper methods (isMinor, isAdult, isSenior)
    - Age categories (infant, child, teenager, adult, senior)
    - Birth year calculation
- **Internationalization (i18n)**
    - English and French error messages
    - Easy language switching via `FailureMessages.setLanguage()`
- **Core features**
    - Immutable Value Objects
    - Functional error handling with `Either` from dartz
    - Proper equality using equatable
    - Comprehensive validation failures
