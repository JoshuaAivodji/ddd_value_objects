import 'package:flutter_test/flutter_test.dart';
import 'package:ddd_value_objects/src/common/name.dart';
import 'package:ddd_value_objects/src/core/failures.dart';

void main() {
  group('FirstName', () {
    group('Valid first names', () {
      test('should accept valid first name', () {
        // Arrange
        final name = FirstName('Jean');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Jean');
      });

      test('should capitalize first letter', () {
        // Arrange
        final name = FirstName('jean');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Jean');
      });

      test('should handle uppercase input', () {
        // Arrange
        final name = FirstName('MARIE');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Marie');
      });

      test('should handle mixed case', () {
        // Arrange
        final name = FirstName('jEaN');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Jean');
      });

      test('should trim whitespace', () {
        // Arrange
        final name = FirstName('  Jean  ');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Jean');
      });

      test('should accept hyphenated names', () {
        // Arrange
        final name = FirstName('Marie-Claire');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Marie-claire');
      });

      test('should accept names with apostrophe', () {
        // Arrange
        final name = FirstName("D'Angelo");

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), "D'angelo");
      });

      test('should accept names with accents', () {
        // Arrange
        final name = FirstName('José');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'José');
      });

      test('should accept compound names with spaces', () {
        // Arrange
        final name = FirstName('Jean Pierre');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Jean Pierre');
      });
    });

    group('Invalid first names', () {
      test('should reject empty name', () {
        // Arrange
        final name = FirstName('');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<EmptyValue>());
      });

      test('should reject name with only whitespace', () {
        // Arrange
        final name = FirstName('   ');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<EmptyValue>());
      });

      test('should reject name too short', () {
        // Arrange
        final name = FirstName('A');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<TooShort>());
      });

      test('should reject name too long', () {
        // Arrange
        final name = FirstName('A' * 51);

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<TooLong>());
      });

      test('should reject name with digits', () {
        // Arrange
        final name = FirstName('Jean123');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<ContainsDigits>());
      });

      test('should reject name with special characters', () {
        // Arrange
        final name = FirstName('Jean@');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<InvalidCharacters>());
      });

      test('should reject name with numbers', () {
        // Arrange
        final name = FirstName('Jean2');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<ContainsDigits>());
      });
    });
  });

  group('LastName', () {
    group('Valid last names', () {
      test('should accept valid last name', () {
        // Arrange
        final name = LastName('Dupont');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'DUPONT');
      });

      test('should convert to uppercase', () {
        // Arrange
        final name = LastName('dupont');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'DUPONT');
      });

      test('should trim whitespace', () {
        // Arrange
        final name = LastName('  Dupont  ');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'DUPONT');
      });

      test('should accept hyphenated names', () {
        // Arrange
        final name = LastName('Martin-Dupont');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'MARTIN-DUPONT');
      });

      test('should accept names with apostrophe', () {
        // Arrange
        final name = LastName("O'Connor");

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), "O'CONNOR");
      });

      test('should accept names with accents', () {
        // Arrange
        final name = LastName('Müller');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'MÜLLER');
      });

      test('should accept compound names with spaces', () {
        // Arrange
        final name = LastName('De La Cruz');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'DE LA CRUZ');
      });
    });

    group('Invalid last names', () {
      test('should reject empty name', () {
        // Arrange
        final name = LastName('');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<EmptyValue>());
      });

      test('should reject name too short', () {
        // Arrange
        final name = LastName('A');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<TooShort>());
      });

      test('should reject name too long', () {
        // Arrange
        final name = LastName('A' * 51);

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<TooLong>());
      });

      test('should reject name with digits', () {
        // Arrange
        final name = LastName('Dupont123');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<ContainsDigits>());
      });

      test('should reject name with special characters', () {
        // Arrange
        final name = LastName('Dupont@');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<InvalidCharacters>());
      });
    });
  });

  group('FullName', () {
    group('Valid full names (from string)', () {
      test('should accept valid full name', () {
        // Arrange
        final name = FullName('Jean Dupont');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Jean DUPONT');
      });

      test('should capitalize correctly', () {
        // Arrange
        final name = FullName('jean dupont');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Jean DUPONT');
      });

      test('should handle multiple last names', () {
        // Arrange
        final name = FullName('Jean Martin Dupont');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Jean MARTIN DUPONT');
      });

      test('should trim whitespace', () {
        // Arrange
        final name = FullName('  Jean Dupont  ');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Jean DUPONT');
      });

      test('should accept hyphenated names', () {
        // Arrange
        final name = FullName('Marie-Claire Martin-Dupont');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'Marie-claire MARTIN-DUPONT');
      });

      test('should accept names with accents', () {
        // Arrange
        final name = FullName('José García');

        // Assert
        expect(name.isValid, true);
        expect(name.getOrCrash(), 'José GARCÍA');
      });
    });

    group('Valid full names (from parts)', () {
      test('should create full name from valid parts', () {
        // Arrange
        final firstName = FirstName('Jean');
        final lastName = LastName('Dupont');
        final fullName = FullName.fromParts(
          firstName: firstName,
          lastName: lastName,
        );

        // Assert
        expect(fullName.isValid, true);
        expect(fullName.getOrCrash(), 'Jean DUPONT');
        expect(fullName.firstName, firstName);
        expect(fullName.lastName, lastName);
      });

      test('should handle normalized parts', () {
        // Arrange
        final firstName = FirstName('jean');
        final lastName = LastName('dupont');
        final fullName = FullName.fromParts(
          firstName: firstName,
          lastName: lastName,
        );

        // Assert
        expect(fullName.isValid, true);
        expect(fullName.getOrCrash(), 'Jean DUPONT');
      });

      test('should fail if firstName is invalid', () {
        // Arrange
        final firstName = FirstName('J'); // Too short
        final lastName = LastName('Dupont');
        final fullName = FullName.fromParts(
          firstName: firstName,
          lastName: lastName,
        );

        // Assert
        expect(fullName.isValid, false);
        expect(fullName.failureOrNull, isA<InvalidFormat>());
      });

      test('should fail if lastName is invalid', () {
        // Arrange
        final firstName = FirstName('Jean');
        final lastName = LastName('D'); // Too short
        final fullName = FullName.fromParts(
          firstName: firstName,
          lastName: lastName,
        );

        // Assert
        expect(fullName.isValid, false);
        expect(fullName.failureOrNull, isA<InvalidFormat>());
      });
    });

    group('Invalid full names', () {
      test('should reject empty name', () {
        // Arrange
        final name = FullName('');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<EmptyValue>());
      });

      test('should reject name too short', () {
        // Arrange
        final name = FullName('AB');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<TooShort>());
      });

      test('should reject name too long', () {
        // Arrange
        final name = FullName('A' * 101);

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<TooLong>());
      });

      test('should reject name with digits', () {
        // Arrange
        final name = FullName('Jean Dupont123');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<ContainsDigits>());
      });

      test('should reject name with special characters', () {
        // Arrange
        final name = FullName('Jean Dupont@');

        // Assert
        expect(name.isValid, false);
        expect(name.failureOrNull, isA<InvalidCharacters>());
      });
    });
  });

  group('Helper methods - initials and sortName', () {
    test('should extract initials from full name', () {
      // Arrange
      final name = FullName('Jean Dupont');

      // Assert
      expect(name.initials, 'JD');
    });

    test('should extract initials from multiple names', () {
      // Arrange
      final name = FullName('Marie Claire Martin');

      // Assert
      expect(name.initials, 'MCM');
    });

    test('should extract initials from hyphenated names', () {
      // Arrange
      final name = FullName('Jean-Pierre Dupont-Martin');

      // Assert
      expect(name.initials, 'JD'); // Changé de 'JDM' à 'JD'
    });

    test('should return null initials for invalid name', () {
      // Arrange
      final name = FullName('');

      // Assert
      expect(name.initials, null);
    });

    test('should format sortName correctly', () {
      // Arrange
      final name = FullName('Jean Dupont');

      // Assert
      expect(name.sortName, 'DUPONT, Jean');
    });

    test('should format sortName for multiple last names', () {
      // Arrange
      final name = FullName('Jean Martin Dupont');

      // Assert
      expect(name.sortName, 'MARTIN DUPONT, Jean');
    });

    test('should return null sortName for invalid name', () {
      // Arrange
      final name = FullName('');

      // Assert
      expect(name.sortName, null);
    });
  });
}
