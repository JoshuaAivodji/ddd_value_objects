import 'package:dartz/dartz.dart';
import '../core/value_object.dart';
import '../core/value_failure.dart';
import '../core/failures.dart';

/// Value Object for a first name
class FirstName extends ValueObject<String> {
  @override
  final Either<ValueFailure, String> value;

  factory FirstName(String input) {
    return FirstName._(_validate(input));
  }

  const FirstName._(this.value);

  static Either<ValueFailure, String> _validate(String input) {
    if (input.trim().isEmpty) {
      return left(const EmptyValue());
    }

    final trimmed = input.trim();

    if (trimmed.length < 2) {
      return left(TooShort(minLength: 2, actualLength: trimmed.length));
    }

    if (trimmed.length > 50) {
      return left(TooLong(maxLength: 50, actualLength: trimmed.length));
    }

    if (trimmed.contains(RegExp(r'[0-9]'))) {
      return left(const ContainsDigits());
    }

    if (!RegExp(r"^[\p{L}\s\-']+$", unicode: true).hasMatch(trimmed)) {
      return left(const InvalidCharacters());
    }

    final capitalized = _capitalize(trimmed);

    return right(capitalized);
  }

  static String _capitalize(String input) {
    return input
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}

/// Value Object for a last name
class LastName extends ValueObject<String> {
  @override
  final Either<ValueFailure, String> value;

  factory LastName(String input) {
    return LastName._(_validate(input));
  }

  const LastName._(this.value);

  static Either<ValueFailure, String> _validate(String input) {
    if (input.trim().isEmpty) {
      return left(const EmptyValue());
    }

    final trimmed = input.trim();

    if (trimmed.length < 2) {
      return left(TooShort(minLength: 2, actualLength: trimmed.length));
    }

    if (trimmed.length > 50) {
      return left(TooLong(maxLength: 50, actualLength: trimmed.length));
    }

    if (trimmed.contains(RegExp(r'[0-9]'))) {
      return left(const ContainsDigits());
    }

    if (!RegExp(r"^[\p{L}\s\-']+$", unicode: true).hasMatch(trimmed)) {
      return left(const InvalidCharacters());
    }

    final capitalized = trimmed.toUpperCase();

    return right(capitalized);
  }
}

/// Value Object for a full name
class FullName extends ValueObject<String> {
  @override
  final Either<ValueFailure, String> value;

  final FirstName? firstName;
  final LastName? lastName;

  factory FullName(String input) {
    return FullName._(_validate(input), null, null);
  }

  factory FullName.fromParts({
    required FirstName firstName,
    required LastName lastName,
  }) {
    if (!firstName.isValid || !lastName.isValid) {
      return FullName._(
        left(const InvalidFormat(fieldName: 'FullName')),
        firstName,
        lastName,
      );
    }

    final fullName = '${firstName.getOrCrash()} ${lastName.getOrCrash()}';
    return FullName._(right(fullName), firstName, lastName);
  }

  const FullName._(this.value, this.firstName, this.lastName);

  static Either<ValueFailure, String> _validate(String input) {
    if (input.trim().isEmpty) {
      return left(const EmptyValue());
    }

    final trimmed = input.trim();

    if (trimmed.length < 3) {
      return left(TooShort(minLength: 3, actualLength: trimmed.length));
    }

    if (trimmed.length > 100) {
      return left(TooLong(maxLength: 100, actualLength: trimmed.length));
    }

    if (trimmed.contains(RegExp(r'[0-9]'))) {
      return left(const ContainsDigits());
    }

    if (!RegExp(r"^[\p{L}\s\-']+$", unicode: true).hasMatch(trimmed)) {
      return left(const InvalidCharacters());
    }

    final capitalized = _capitalize(trimmed);

    return right(capitalized);
  }

  static String _capitalize(String input) {
    final parts = input.split(' ');
    if (parts.isEmpty) return input;

    final first = parts.first;
    final capitalizedFirst = first.isEmpty
        ? first
        : first[0].toUpperCase() + first.substring(1).toLowerCase();

    final rest = parts.skip(1).map((word) => word.toUpperCase()).join(' ');

    return rest.isEmpty ? capitalizedFirst : '$capitalizedFirst $rest';
  }

  String? get extractedFirstName {
    return value.fold((_) => null, (name) => name.split(' ').first);
  }

  String? get extractedLastName {
    return value.fold((_) => null, (name) {
      final parts = name.split(' ');
      return parts.length > 1 ? parts.skip(1).join(' ') : null;
    });
  }
}
