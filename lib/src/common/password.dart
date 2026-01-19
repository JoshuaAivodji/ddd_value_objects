import 'package:dartz/dartz.dart';

import '../core/failures.dart';
import '../core/value_failure.dart';
import '../core/value_object.dart';
import 'config/password_validation_config.dart';

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure, String> value;

  final PasswordValidationConfig config;

  factory Password(
    String input, {
    PasswordValidationConfig config = PasswordValidationConfig.strong,
  }) {
    return Password._(_validate(input, config), config);
  }

  const Password._(this.value, this.config);

  static Either<ValueFailure, String> _validate(
    String input,
    PasswordValidationConfig config,
  ) {
    if (input.isEmpty) {
      return left(const EmptyValue());
    }

    // Check the minimum length
    if (input.length < config.minLength) {
      return left(
        TooShort(minLength: config.minLength, actualLength: input.length),
      );
    }

    // Check the maximum length
    if (config.maxLength != null && input.length > config.maxLength!) {
      return left(
        TooLong(maxLength: config.maxLength!, actualLength: input.length),
      );
    }

    // Checks for the presence of an uppercase letter
    if (config.requireUpperCase && !input.contains(RegExp(r'[A-Z]'))) {
      return left(const NoUpperCase());
    }

    // Checks for the presence of a lowercase letter
    if (config.requireLowerCase && !input.contains(RegExp(r'[a-z]'))) {
      return left(const NoLowerCase());
    }

    // Checks for the presence of a digit
    if (config.requireDigit && !input.contains(RegExp(r'[0-9]'))) {
      return left(const NoDigit());
    }

    // Checks for the presence of a special character
    if (config.requireSpecialCharacter &&
        !input.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return left(const NoSpecialCharacter());
    }

    return right(input);
  }

  /// Evaluates password strength (0-100)
  int get strength {
    return value.fold((_) => 0, (password) {
      int score = 0;

      // Length
      if (password.length >= 8) score += 20;
      if (password.length >= 12) score += 10;
      if (password.length >= 16) score += 10;

      // Complexity
      if (password.contains(RegExp(r'[A-Z]'))) score += 15;
      if (password.contains(RegExp(r'[a-z]'))) score += 15;
      if (password.contains(RegExp(r'[0-9]'))) score += 15;
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score += 15;

      return score.clamp(0, 100);
    });
  }

  /// Returns the strength level (weak, medium, strong)
  String get strengthLevel {
    final score = strength;
    if (score < 40) return 'weak';
    if (score < 70) return 'medium';
    return 'strong';
  }

  bool get hasUpperCase {
    return value.fold(
      (_) => false,
      (password) => password.contains(RegExp(r'[A-Z]')),
    );
  }

  bool get hasLowerCase {
    return value.fold(
      (_) => false,
      (password) => password.contains(RegExp(r'[a-z]')),
    );
  }

  bool get hasDigit {
    return value.fold(
      (_) => false,
      (password) => password.contains(RegExp(r'[0-9]')),
    );
  }

  bool get hasSpecialCharacter {
    return value.fold(
      (_) => false,
      (password) => password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    );
  }
}
