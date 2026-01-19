import 'package:dartz/dartz.dart';
import '../core/value_object.dart';
import '../core/value_failure.dart';
import '../core/failures.dart';

class Age extends ValueObject<int> {
  @override
  final Either<ValueFailure, int> value;

  static const int defaultMinAge = 0;
  static const int defaultMaxAge = 150;

  final int minAge;
  final int maxAge;

  factory Age(
    int input, {
    int minAge = defaultMinAge,
    int maxAge = defaultMaxAge,
  }) {
    return Age._(_validate(input, minAge, maxAge), minAge, maxAge);
  }

  const Age._(this.value, this.minAge, this.maxAge);

  static Either<ValueFailure, int> _validate(
    int input,
    int minAge,
    int maxAge,
  ) {
    if (input < 0) {
      return left(const NegativeValue());
    }

    if (input < minAge) {
      return left(BelowMinimum(minimum: minAge, actualValue: input));
    }

    if (input > maxAge) {
      return left(ExceedsMaximum(maximum: maxAge, actualValue: input));
    }

    return right(input);
  }

  /// Check whether the person is a minor (< 18 years old)
  bool get isMinor {
    return value.fold((_) => false, (age) => age < 18);
  }

  /// Verify that the person is an adult (>= 18 years old)
  bool get isAdult {
    return value.fold((_) => false, (age) => age >= 18);
  }

  /// Check if the person is a senior citizen (>= 65 years old)
  bool get isSenior {
    return value.fold((_) => false, (age) => age >= 65);
  }

  /// Returns the age category
  String get category {
    return value.fold((_) => 'unknown', (age) {
      if (age < 2) return 'infant';
      if (age < 13) return 'child';
      if (age < 18) return 'teenager';
      if (age < 65) return 'adult';
      return 'senior';
    });
  }

  /// Calculates the approximate year of birth
  int? birthYear({int? currentYear}) {
    final year = currentYear ?? DateTime.now().year;
    return value.fold((_) => null, (age) => year - age);
  }
}
