import 'package:flutter_test/flutter_test.dart';
import 'package:ddd_value_objects/src/common/age.dart';
import 'package:ddd_value_objects/src/core/failures.dart';

void main() {
  group('Age', () {
    group('Valid ages', () {
      test('should accept valid age', () {
        // Arrange
        final age = Age(25);

        // Assert
        expect(age.isValid, true);
        expect(age.getOrCrash(), 25);
      });

      test('should accept zero age', () {
        // Arrange
        final age = Age(0);

        // Assert
        expect(age.isValid, true);
        expect(age.getOrCrash(), 0);
      });

      test('should accept maximum default age (150)', () {
        // Arrange
        final age = Age(150);

        // Assert
        expect(age.isValid, true);
        expect(age.getOrCrash(), 150);
      });

      test('should accept age within custom range', () {
        // Arrange
        final age = Age(25, minAge: 18, maxAge: 65);

        // Assert
        expect(age.isValid, true);
        expect(age.getOrCrash(), 25);
      });

      test('should accept minimum custom age', () {
        // Arrange
        final age = Age(18, minAge: 18, maxAge: 65);

        // Assert
        expect(age.isValid, true);
        expect(age.getOrCrash(), 18);
      });

      test('should accept maximum custom age', () {
        // Arrange
        final age = Age(65, minAge: 18, maxAge: 65);

        // Assert
        expect(age.isValid, true);
        expect(age.getOrCrash(), 65);
      });
    });

    group('Invalid ages', () {
      test('should reject negative age', () {
        // Arrange
        final age = Age(-1);

        // Assert
        expect(age.isValid, false);
        expect(age.failureOrNull, isA<NegativeValue>());
      });

      test('should reject age exceeding default maximum', () {
        // Arrange
        final age = Age(151);

        // Assert
        expect(age.isValid, false);
        expect(age.failureOrNull, isA<ExceedsMaximum>());
        final failure = age.failureOrNull as ExceedsMaximum;
        expect(failure.maximum, 150);
        expect(failure.actualValue, 151);
      });

      test('should reject age below custom minimum', () {
        // Arrange
        final age = Age(17, minAge: 18);

        // Assert
        expect(age.isValid, false);
        expect(age.failureOrNull, isA<BelowMinimum>());
        final failure = age.failureOrNull as BelowMinimum;
        expect(failure.minimum, 18);
        expect(failure.actualValue, 17);
      });

      test('should reject age exceeding custom maximum', () {
        // Arrange
        final age = Age(66, minAge: 18, maxAge: 65);

        // Assert
        expect(age.isValid, false);
        expect(age.failureOrNull, isA<ExceedsMaximum>());
        final failure = age.failureOrNull as ExceedsMaximum;
        expect(failure.maximum, 65);
        expect(failure.actualValue, 66);
      });
    });

    group('Helper methods - isMinor/isAdult/isSenior', () {
      test('should identify minor (< 18)', () {
        // Arrange
        final age = Age(15);

        // Assert
        expect(age.isMinor, true);
        expect(age.isAdult, false);
        expect(age.isSenior, false);
      });

      test('should identify adult (>= 18, < 65)', () {
        // Arrange
        final age = Age(30);

        // Assert
        expect(age.isMinor, false);
        expect(age.isAdult, true);
        expect(age.isSenior, false);
      });

      test('should identify senior (>= 65)', () {
        // Arrange
        final age = Age(70);

        // Assert
        expect(age.isMinor, false);
        expect(age.isAdult, true);
        expect(age.isSenior, true);
      });

      test('should identify 18 as adult', () {
        // Arrange
        final age = Age(18);

        // Assert
        expect(age.isMinor, false);
        expect(age.isAdult, true);
      });

      test('should identify 65 as senior', () {
        // Arrange
        final age = Age(65);

        // Assert
        expect(age.isSenior, true);
      });

      test('should return false for all helpers when invalid', () {
        // Arrange
        final age = Age(-1);

        // Assert
        expect(age.isMinor, false);
        expect(age.isAdult, false);
        expect(age.isSenior, false);
      });
    });

    group('Helper methods - category', () {
      test('should categorize as infant (< 2)', () {
        // Arrange
        final age = Age(1);

        // Assert
        expect(age.category, 'infant');
      });

      test('should categorize as child (2-12)', () {
        // Arrange
        final age = Age(8);

        // Assert
        expect(age.category, 'child');
      });

      test('should categorize as teenager (13-17)', () {
        // Arrange
        final age = Age(15);

        // Assert
        expect(age.category, 'teenager');
      });

      test('should categorize as adult (18-64)', () {
        // Arrange
        final age = Age(30);

        // Assert
        expect(age.category, 'adult');
      });

      test('should categorize as senior (>= 65)', () {
        // Arrange
        final age = Age(70);

        // Assert
        expect(age.category, 'senior');
      });

      test('should categorize edge case - 2 years as child', () {
        // Arrange
        final age = Age(2);

        // Assert
        expect(age.category, 'child');
      });

      test('should categorize edge case - 13 years as teenager', () {
        // Arrange
        final age = Age(13);

        // Assert
        expect(age.category, 'teenager');
      });

      test('should categorize edge case - 18 years as adult', () {
        // Arrange
        final age = Age(18);

        // Assert
        expect(age.category, 'adult');
      });

      test('should categorize edge case - 65 years as senior', () {
        // Arrange
        final age = Age(65);

        // Assert
        expect(age.category, 'senior');
      });

      test('should return unknown for invalid age', () {
        // Arrange
        final age = Age(-1);

        // Assert
        expect(age.category, 'unknown');
      });
    });

    group('Helper methods - birthYear', () {
      test('should calculate birth year with default current year', () {
        // Arrange
        final age = Age(25);
        final currentYear = DateTime.now().year;

        // Assert
        expect(age.birthYear(), currentYear - 25);
      });

      test('should calculate birth year with custom current year', () {
        // Arrange
        final age = Age(25);

        // Assert
        expect(age.birthYear(currentYear: 2026), 2001);
      });

      test('should calculate birth year for newborn', () {
        // Arrange
        final age = Age(0);

        // Assert
        expect(age.birthYear(currentYear: 2026), 2026);
      });

      test('should calculate birth year for senior', () {
        // Arrange
        final age = Age(80);

        // Assert
        expect(age.birthYear(currentYear: 2026), 1946);
      });

      test('should return null for invalid age', () {
        // Arrange
        final age = Age(-1);

        // Assert
        expect(age.birthYear(), null);
      });
    });
  });
}
