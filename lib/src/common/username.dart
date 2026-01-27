import 'package:dartz/dartz.dart';
import '../core/value_object.dart';
import '../core/value_failure.dart';
import '../core/failures.dart';

class Username extends ValueObject<String> {
  @override
  final Either<ValueFailure, String> value;

  static const int defaultMinLength = 3;
  static const int defaultMaxLength = 20;

  final int minLength;
  final int maxLength;

  factory Username(
    String input, {
    int minLength = defaultMinLength,
    int maxLength = defaultMaxLength,
  }) {
    return Username._(
      _validate(input, minLength, maxLength),
      minLength,
      maxLength,
    );
  }

  const Username._(this.value, this.minLength, this.maxLength);

  static Either<ValueFailure, String> _validate(
    String input,
    int minLength,
    int maxLength,
  ) {
    if (input.trim().isEmpty) {
      return left(const EmptyValue());
    }

    final trimmed = input.trim();

    if (trimmed.length < minLength) {
      return left(TooShort(minLength: minLength, actualLength: trimmed.length));
    }

    if (trimmed.length > maxLength) {
      return left(TooLong(maxLength: maxLength, actualLength: trimmed.length));
    }

    // Verify that the username contains only letters, numbers, and underscores.
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(trimmed)) {
      return left(const InvalidUsername());
    }

    return right(trimmed.toLowerCase());
  }

  bool get hasUnderscore {
    return value.fold((_) => false, (username) => username.contains('_'));
  }

  bool get hasDigit {
    return value.fold(
      (_) => false,
      (username) => username.contains(RegExp(r'[0-9]')),
    );
  }

  bool get isAlphaOnly {
    return value.fold(
      (_) => false,
      (username) => RegExp(r'^[a-zA-Z]+$').hasMatch(username),
    );
  }

  int get length {
    return value.fold((_) => 0, (username) => username.length);
  }
}
