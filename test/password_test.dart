import 'package:ddd_value_objects/src/common/config/password_validation_config.dart';
import 'package:ddd_value_objects/src/core/i18n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ddd_value_objects/src/common/password.dart';
import 'package:ddd_value_objects/src/core/failures.dart';

void main() {
  group('Password', () {
    group('Strong configuration (default)', () {
      test('should accept valid strong password', () {
        // Arrange
        final password = Password('MyP@ssw0rd123');

        // Assert
        expect(password.isValid, true);
        expect(password.getOrCrash(), 'MyP@ssw0rd123');
      });

      test('should reject password without uppercase', () {
        // Arrange
        final password = Password('myp@ssw0rd123');

        // Assert
        expect(password.isValid, false);
        expect(password.failureOrNull, isA<NoUpperCase>());
      });

      test('should reject password without lowercase', () {
        // Arrange
        final password = Password('MYP@SSW0RD123');

        // Assert
        expect(password.isValid, false);
        expect(password.failureOrNull, isA<NoLowerCase>());
      });

      test('should reject password without digit', () {
        // Arrange
        final password = Password('MyP@ssword');

        // Assert
        expect(password.isValid, false);
        expect(password.failureOrNull, isA<NoDigit>());
      });

      test('should reject password without special character', () {
        // Arrange
        final password = Password('MyPassword123');

        // Assert
        expect(password.isValid, false);
        expect(password.failureOrNull, isA<NoSpecialCharacter>());
      });

      test('should reject password too short', () {
        // Arrange
        final password = Password('MyP@ss1');

        // Assert
        expect(password.isValid, false);
        expect(password.failureOrNull, isA<TooShort>());
        final failure = password.failureOrNull as TooShort;
        expect(failure.minLength, 8);
        expect(failure.actualLength, 7);
      });

      test('should reject empty password', () {
        // Arrange
        final password = Password('');

        // Assert
        expect(password.isValid, false);
        expect(password.failureOrNull, isA<EmptyValue>());
      });
    });

    group('Medium configuration', () {
      test('should accept password without special character', () {
        // Arrange
        final password = Password(
          'MyPassword123',
          config: PasswordValidationConfig.medium,
        );

        // Assert
        expect(password.isValid, true);
      });

      test('should accept 6 character password', () {
        // Arrange
        final password = Password(
          'MyPas1',
          config: PasswordValidationConfig.medium,
        );

        // Assert
        expect(password.isValid, true);
      });

      test('should reject password too short (less than 6)', () {
        // Arrange
        final password = Password(
          'MyP1',
          config: PasswordValidationConfig.medium,
        );

        // Assert
        expect(password.isValid, false);
        expect(password.failureOrNull, isA<TooShort>());
      });
    });

    group('Weak configuration', () {
      test('should accept simple 4 character password', () {
        // Arrange
        final password = Password(
          'pass',
          config: PasswordValidationConfig.weak,
        );

        // Assert
        expect(password.isValid, true);
      });

      test('should accept password without uppercase', () {
        // Arrange
        final password = Password(
          'password',
          config: PasswordValidationConfig.weak,
        );

        // Assert
        expect(password.isValid, true);
      });

      test('should accept password without digit', () {
        // Arrange
        final password = Password(
          'password',
          config: PasswordValidationConfig.weak,
        );

        // Assert
        expect(password.isValid, true);
      });

      test('should reject password too short (less than 4)', () {
        // Arrange
        final password = Password('abc', config: PasswordValidationConfig.weak);

        // Assert
        expect(password.isValid, false);
        expect(password.failureOrNull, isA<TooShort>());
      });
    });

    group('Custom configuration', () {
      test('should respect custom minLength', () {
        // Arrange
        final config = PasswordValidationConfig(
          minLength: 12,
          requireUpperCase: false,
          requireLowerCase: false,
          requireDigit: false,
          requireSpecialCharacter: false,
        );
        final password = Password('short', config: config);

        // Assert
        expect(password.isValid, false);
        expect(password.failureOrNull, isA<TooShort>());
      });

      test('should respect custom maxLength', () {
        // Arrange
        final config = PasswordValidationConfig(
          minLength: 4,
          maxLength: 10,
          requireUpperCase: false,
          requireLowerCase: false,
          requireDigit: false,
          requireSpecialCharacter: false,
        );
        final password = Password('thisistoolong', config: config);

        // Assert
        expect(password.isValid, false);
        expect(password.failureOrNull, isA<TooLong>());
        final failure = password.failureOrNull as TooLong;
        expect(failure.maxLength, 10);
        expect(failure.actualLength, 13);
      });

      test('should allow custom rules combination', () {
        // Arrange
        final config = PasswordValidationConfig(
          minLength: 6,
          requireUpperCase: true,
          requireLowerCase: false,
          requireDigit: true,
          requireSpecialCharacter: false,
        );
        final password = Password('PASSWORD123', config: config);

        // Assert
        expect(password.isValid, true);
      });
    });

    group('Password strength', () {
      test('should calculate strength for strong password', () {
        // Arrange
        final password = Password('MyP@ssw0rd123456');

        // Assert
        expect(password.strength, greaterThanOrEqualTo(80));
        expect(password.strengthLevel, 'strong');
      });

      test('should calculate strength for medium password', () {
        // Arrange
        final password = Password(
          'MyPassword1',
          config: PasswordValidationConfig.medium,
        );

        // Assert
        expect(password.strength, greaterThanOrEqualTo(40));
        expect(password.strength, lessThan(70));
        expect(password.strengthLevel, 'medium');
      });

      test('should calculate strength for weak password', () {
        // Arrange
        final password = Password(
          'pass',
          config: PasswordValidationConfig.weak,
        );

        // Assert
        expect(password.strength, lessThan(40));
        expect(password.strengthLevel, 'weak');
      });

      test('should return 0 strength for invalid password', () {
        // Arrange
        final password = Password('');

        // Assert
        expect(password.strength, 0);
      });
    });

    group('Helper methods', () {
      test('hasUpperCase should return true when uppercase present', () {
        // Arrange
        final password = Password(
          'MyPassword1@',
          config: PasswordValidationConfig.medium,
        );

        // Assert
        expect(password.hasUpperCase, true);
      });

      test('hasUpperCase should return false when no uppercase', () {
        // Arrange
        final password = Password(
          'mypassword1@',
          config: PasswordValidationConfig.weak,
        );

        // Assert
        expect(password.hasUpperCase, false);
      });

      test('hasLowerCase should return true when lowercase present', () {
        // Arrange
        final password = Password(
          'MyPassword1@',
          config: PasswordValidationConfig.medium,
        );

        // Assert
        expect(password.hasLowerCase, true);
      });

      test('hasDigit should return true when digit present', () {
        // Arrange
        final password = Password(
          'MyPassword1@',
          config: PasswordValidationConfig.medium,
        );

        // Assert
        expect(password.hasDigit, true);
      });

      test(
        'hasSpecialCharacter should return true when special char present',
        () {
          // Arrange
          final password = Password('MyPassword1@');

          // Assert
          expect(password.hasSpecialCharacter, true);
        },
      );

      test('hasSpecialCharacter should return false when no special char', () {
        // Arrange
        final password = Password(
          'MyPassword1',
          config: PasswordValidationConfig.medium,
        );

        // Assert
        expect(password.hasSpecialCharacter, false);
      });

      test('helper methods should return false for invalid password', () {
        // Arrange
        final password = Password('');

        // Assert
        expect(password.hasUpperCase, false);
        expect(password.hasLowerCase, false);
        expect(password.hasDigit, false);
        expect(password.hasSpecialCharacter, false);
      });
    });

    group('i18n', () {
      test('should show NoUpperCase error in English', () {
        // Arrange
        FailureMessages.setLanguage(Language.en);
        final password = Password('myp@ssw0rd123');

        // Assert
        expect(
          password.failureOrNull?.message,
          'Password must contain at least one uppercase letter',
        );
      });

      test('should show NoUpperCase error in French', () {
        // Arrange
        FailureMessages.setLanguage(Language.fr);
        final password = Password('myp@ssw0rd123');

        // Assert
        expect(
          password.failureOrNull?.message,
          'Le mot de passe doit contenir au moins une majuscule',
        );
      });

      test('should show NoLowerCase error in English', () {
        // Arrange
        FailureMessages.setLanguage(Language.en);
        final password = Password('MYP@SSW0RD123');

        // Assert
        expect(
          password.failureOrNull?.message,
          'Password must contain at least one lowercase letter',
        );
      });

      test('should show NoDigit error in French', () {
        // Arrange
        FailureMessages.setLanguage(Language.fr);
        final password = Password('MyP@ssword');

        // Assert
        expect(
          password.failureOrNull?.message,
          'Le mot de passe doit contenir au moins un chiffre',
        );
      });

      test('should show NoSpecialCharacter error in English', () {
        // Arrange
        FailureMessages.setLanguage(Language.en);
        final password = Password('MyPassword123');

        // Assert
        expect(
          password.failureOrNull?.message,
          'Password must contain at least one special character',
        );
      });
    });
  });
}
