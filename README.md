# DDD Value Objects

A collection of reusable Value Objects for Domain-Driven Design (DDD) in Flutter/Dart applications.

[![pub package](https://img.shields.io/pub/v/ddd_value_objects.svg)](https://pub.dev/packages/ddd_value_objects)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

This package provides ready-to-use Value Objects with built-in validation, immutability, and proper equality:

-  **EmailAddress** - Email validation with RFC 5322 compliance
-  **Password** - Configurable password validation (strong, medium, weak presets)
-  **Name** - FirstName, LastName, and FullName with proper capitalization
-  **Age** - Age validation with customizable constraints
-  **Url** - URL validation with protocol, domain, and path extraction
-  **Username** - Username validation (alphanumeric + underscore)


### Core Features

-  **Internationalization** - Built-in support for English and French error messages
-  **Immutability** - All Value Objects are immutable by design
-  **Functional approach** - Uses `Either` for validation results
-  **Type-safe** - Leverage Dart's type system for domain modeling
-  **Well-tested** - Comprehensive test coverage (159+ tests)

## Installation

Add this to your `pubspec.yaml`:
```yaml
dependencies:
  ddd_value_objects: ^0.1.0
```

Then run:
```bash
flutter pub get
```

## Usage

### EmailAddress
```dart
import 'package:ddd_value_objects/ddd_value_objects.dart';

// Valid email
final email = EmailAddress('user@example.com');
if (email.isValid) {
print(email.getOrCrash()); // "user@example.com"
print(email.domain); // "example.com"
print(email.localPart); // "user"
}

// Check email type
final personalEmail = EmailAddress('user@gmail.com');
print(personalEmail.isBusinessEmail); // false

final businessEmail = EmailAddress('contact@company.com');
print(businessEmail.isBusinessEmail); // true

// Detect disposable emails
final disposableEmail = EmailAddress('temp@tempmail.com');
print(disposableEmail.isDisposable); // true

// Invalid email
final invalidEmail = EmailAddress('not-an-email');
print(invalidEmail.isValid); // false
print(invalidEmail.failureOrNull?.message); // "Invalid email address"
```

### Password
```dart
// Strong password (default - requires uppercase, lowercase, digit, special char, min 8)
final strongPass = Password('MyP@ssw0rd123');
print(strongPass.isValid); // true
print(strongPass.strength); // 85 (0-100 scale)
print(strongPass.strengthLevel); // "strong"

// Medium password (min 6, no special char required)
final mediumPass = Password('MyPass123', config: PasswordValidationConfig.medium);

// Weak password (min 4, only lowercase required)
final weakPass = Password('pass', config: PasswordValidationConfig.weak);

// Custom configuration
final customPass = Password('test1234', config: PasswordValidationConfig(
  minLength: 8,
  requireUpperCase: false,
  requireSpecialCharacter: false,
));

// Check password characteristics
print(strongPass.hasUpperCase); // true
print(strongPass.hasDigit); // true
print(strongPass.hasSpecialCharacter); // true
```

### Name
```dart
// FirstName - automatically capitalizes
final firstName = FirstName('joshua');
print(firstName.getOrCrash()); // "Joshua"

// LastName - converts to uppercase
final lastName = LastName('dalton');
print(lastName.getOrCrash()); // "DALTON"

// FullName - from string
final fullName = FullName('joshua dalton');
print(fullName.getOrCrash()); // "Joshua DALTON"
print(fullName.extractedFirstName); // "Joshua"
print(fullName.extractedLastName); // "DALTON"

// FullName - from parts
final fullNameFromParts = FullName.fromParts(
  firstName: FirstName('Marie'),
  lastName: LastName('Martin'),
);
print(fullNameFromParts.getOrCrash()); // "Marie MARTIN"

// New helpers
print(fullName.initials); // "JD"
print(fullName.sortName); // "DUPONT, Jean"

// Supports international characters
final accentedName = FirstName('josé');
print(accentedName.getOrCrash()); // "José"

// Supports hyphens and apostrophes
final hyphenatedName = FirstName("marie-claire");
print(hyphenatedName.getOrCrash()); // "Marie-claire"
```

### Age
```dart
// Standard age validation (0-150)
final age = Age(25);
print(age.isValid); // true
print(age.isAdult); // true
print(age.isMinor); // false
print(age.isSenior); // false
print(age.category); // "adult"
print(age.birthYear()); // Calculates birth year

// Custom age constraints
final adultOnly = Age(17, minAge: 18); // Invalid
final childAge = Age(8, maxAge: 12); // Valid

// Age categories
final infant = Age(1);
print(infant.category); // "infant" (< 2)

final child = Age(8);
print(child.category); // "child" (2-12)

final teenager = Age(15);
print(teenager.category); // "teenager" (13-17)

final adult = Age(30);
print(adult.category); // "adult" (18-64)

final senior = Age(70);
print(senior.category); // "senior" (>= 65)
```

### Url
```dart
// Valid URLs
final url = Url('https://example.com');
print(url.isValid); // true
print(url.protocol); // "https"
print(url.domain); // "example.com"
print(url.path); // "/"
print(url.isSecure); // true

// URL with path and query parameters
final complexUrl = Url('https://api.example.com:8080/users?page=1&limit=10#section');
print(complexUrl.domain); // "api.example.com"
print(complexUrl.port); // 8080
print(complexUrl.path); // "/users"
print(complexUrl.queryParameters); // {"page": "1", "limit": "10"}
print(complexUrl.fragment); // "section"
print(complexUrl.hasQueryParameters); // true

// Invalid URLs
final invalidUrl = Url('example.com'); // Missing protocol
print(invalidUrl.isValid); // false
print(invalidUrl.failureOrNull?.message); // "URL must have a protocol..."

final httpUrl = Url('http://example.com');
print(httpUrl.isSecure); // false (not HTTPS)
```

### Username
```dart
// Valid username
final username = Username('john_doe');
print(username.isValid); // true
print(username.getOrCrash()); // "john_doe" (normalized to lowercase)

// Automatic normalization
final upperUsername = Username('JohnDoe123');
print(upperUsername.getOrCrash()); // "johndoe123"

// Check username characteristics
print(username.hasUnderscore); // true
print(username.hasDigit); // false
print(username.isAlphaOnly); // false
print(username.length); // 8

// Custom constraints
final shortUsername = Username('ab', minLength: 2); // Valid
final longUsername = Username('verylongusername', maxLength: 10); // Invalid

// Invalid usernames
final invalidUsername = Username('john doe'); // Contains space
print(invalidUsername.isValid); // false

final specialChars = Username('john@doe'); // Special characters
print(specialChars.isValid); // false
```

## Internationalization (i18n)

By default, error messages are in English. You can switch to French or add your own languages:
```dart
import 'package:ddd_value_objects/ddd_value_objects.dart';

// Set language to French
FailureMessages.setLanguage(Language.fr);

final email = EmailAddress('invalid');
print(email.failureOrNull?.message); // "Adresse email invalide"

// Set back to English
FailureMessages.setLanguage(Language.en);
print(email.failureOrNull?.message); // "Invalid email address"
```

## Error Handling

All Value Objects use the `Either` type from `dartz` for functional error handling:
```dart
final email = EmailAddress('test@example.com');

// Pattern 1: Check validity first
if (email.isValid) {
  final value = email.getOrCrash();
  // Use value safely
} else {
  final error = email.failureOrNull;
  print(error?.message);
}

// Pattern 2: Provide default value
final emailString = email.getOrElse('default@example.com');

// Pattern 3: Fold (functional approach)
email.value.fold(
  (failure) => print('Error: ${failure.message}'),
  (validEmail) => print('Valid: $validEmail'),
);
```

## Common Failures

The package includes these common validation failures:

- `EmptyValue` - Value is empty
- `TooShort` - Value is too short
- `TooLong` - Value is too long
- `InvalidFormat` - Invalid format
- `InvalidEmail` - Invalid email format
- `InvalidUrl` - Invalid URL format
- `MissingProtocol` - URL missing protocol
- `InvalidUsername` - Invalid username format
- `NoUpperCase` - Missing uppercase letter
- `NoLowerCase` - Missing lowercase letter
- `NoDigit` - Missing digit
- `NoSpecialCharacter` - Missing special character
- `InvalidCharacters` - Contains invalid characters
- `ContainsDigits` - Contains digits (for names)
- `NegativeValue` - Value is negative
- `BelowMinimum` - Below minimum value
- `ExceedsMaximum` - Exceeds maximum value

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Joshua** - Flutter Developer

## Acknowledgments

- Built with [dartz](https://pub.dev/packages/dartz) for functional programming
- Inspired by Domain-Driven Design principles