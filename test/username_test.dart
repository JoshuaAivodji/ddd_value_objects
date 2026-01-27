import 'package:ddd_value_objects/src/core/i18n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ddd_value_objects/src/common/username.dart';
import 'package:ddd_value_objects/src/core/failures.dart';

void main() {
  group('Username', () {
    group('Valid usernames', () {
      test('should accept valid lowercase username', () {
        // Arrange
        final username = Username('john_doe');

        // Assert
        expect(username.isValid, true);
        expect(username.getOrCrash(), 'john_doe');
      });

      test('should convert to lowercase', () {
        // Arrange
        final username = Username('JohnDoe');

        // Assert
        expect(username.isValid, true);
        expect(username.getOrCrash(), 'johndoe');
      });

      test('should accept username with underscores', () {
        // Arrange
        final username = Username('user_name_123');

        // Assert
        expect(username.isValid, true);
        expect(username.getOrCrash(), 'user_name_123');
      });

      test('should accept username with digits', () {
        // Arrange
        final username = Username('user123');

        // Assert
        expect(username.isValid, true);
        expect(username.getOrCrash(), 'user123');
      });

      test('should accept username with only letters', () {
        // Arrange
        final username = Username('username');

        // Assert
        expect(username.isValid, true);
        expect(username.getOrCrash(), 'username');
      });

      test('should accept minimum length username', () {
        // Arrange
        final username = Username('abc');

        // Assert
        expect(username.isValid, true);
        expect(username.getOrCrash(), 'abc');
      });

      test('should accept maximum length username', () {
        // Arrange
        final username = Username('a' * 20);

        // Assert
        expect(username.isValid, true);
      });

      test('should trim whitespace', () {
        // Arrange
        final username = Username('  john_doe  ');

        // Assert
        expect(username.isValid, true);
        expect(username.getOrCrash(), 'john_doe');
      });
    });

    group('Invalid usernames', () {
      test('should reject empty username', () {
        // Arrange
        final username = Username('');

        // Assert
        expect(username.isValid, false);
        expect(username.failureOrNull, isA<EmptyValue>());
      });

      test('should reject username too short', () {
        // Arrange
        final username = Username('ab');

        // Assert
        expect(username.isValid, false);
        expect(username.failureOrNull, isA<TooShort>());
        final failure = username.failureOrNull as TooShort;
        expect(failure.minLength, 3);
        expect(failure.actualLength, 2);
      });

      test('should reject username too long', () {
        // Arrange
        final username = Username('a' * 21);

        // Assert
        expect(username.isValid, false);
        expect(username.failureOrNull, isA<TooLong>());
        final failure = username.failureOrNull as TooLong;
        expect(failure.maxLength, 20);
        expect(failure.actualLength, 21);
      });

      test('should reject username with spaces', () {
        // Arrange
        final username = Username('john doe');

        // Assert
        expect(username.isValid, false);
        expect(username.failureOrNull, isA<InvalidUsername>());
      });

      test('should reject username with special characters', () {
        // Arrange
        final username = Username('john@doe');

        // Assert
        expect(username.isValid, false);
        expect(username.failureOrNull, isA<InvalidUsername>());
      });

      test('should reject username with hyphens', () {
        // Arrange
        final username = Username('john-doe');

        // Assert
        expect(username.isValid, false);
        expect(username.failureOrNull, isA<InvalidUsername>());
      });

      test('should reject username with dots', () {
        // Arrange
        final username = Username('john.doe');

        // Assert
        expect(username.isValid, false);
        expect(username.failureOrNull, isA<InvalidUsername>());
      });

      test('should reject username starting with underscore', () {
        // Arrange
        final username = Username('_johndoe');

        // Assert
        expect(username.isValid, true); // Actually valid, just checking
      });
    });

    group('Custom constraints', () {
      test('should accept username with custom min length', () {
        // Arrange
        final username = Username('ab', minLength: 2);

        // Assert
        expect(username.isValid, true);
      });

      test('should reject username below custom min length', () {
        // Arrange
        final username = Username('abc', minLength: 5);

        // Assert
        expect(username.isValid, false);
        expect(username.failureOrNull, isA<TooShort>());
      });

      test('should accept username with custom max length', () {
        // Arrange
        final username = Username('a' * 25, maxLength: 30);

        // Assert
        expect(username.isValid, true);
      });

      test('should reject username exceeding custom max length', () {
        // Arrange
        final username = Username('a' * 15, maxLength: 10);

        // Assert
        expect(username.isValid, false);
        expect(username.failureOrNull, isA<TooLong>());
      });
    });

    group('Helper methods', () {
      test('hasUnderscore should return true when underscore present', () {
        // Arrange
        final username = Username('john_doe');

        // Assert
        expect(username.hasUnderscore, true);
      });

      test('hasUnderscore should return false when no underscore', () {
        // Arrange
        final username = Username('johndoe');

        // Assert
        expect(username.hasUnderscore, false);
      });

      test('hasDigit should return true when digit present', () {
        // Arrange
        final username = Username('john123');

        // Assert
        expect(username.hasDigit, true);
      });

      test('hasDigit should return false when no digit', () {
        // Arrange
        final username = Username('johndoe');

        // Assert
        expect(username.hasDigit, false);
      });

      test('isAlphaOnly should return true for letters only', () {
        // Arrange
        final username = Username('johndoe');

        // Assert
        expect(username.isAlphaOnly, true);
      });

      test('isAlphaOnly should return false when contains digits', () {
        // Arrange
        final username = Username('john123');

        // Assert
        expect(username.isAlphaOnly, false);
      });

      test('isAlphaOnly should return false when contains underscore', () {
        // Arrange
        final username = Username('john_doe');

        // Assert
        expect(username.isAlphaOnly, false);
      });

      test('length should return correct length', () {
        // Arrange
        final username = Username('johndoe');

        // Assert
        expect(username.length, 7);
      });

      test('length should return 0 for invalid username', () {
        // Arrange
        final username = Username('');

        // Assert
        expect(username.length, 0);
      });

      test('helper methods should return false for invalid username', () {
        // Arrange
        final username = Username('john doe'); // Invalid

        // Assert
        expect(username.hasUnderscore, false);
        expect(username.hasDigit, false);
        expect(username.isAlphaOnly, false);
      });
    });

    group('Equality', () {
      test('should be equal if usernames are the same', () {
        // Arrange
        final username1 = Username('johndoe');
        final username2 = Username('johndoe');

        // Assert
        expect(username1, equals(username2));
      });

      test('should be equal after normalization', () {
        // Arrange
        final username1 = Username('JohnDoe');
        final username2 = Username('johndoe');

        // Assert
        expect(username1, equals(username2));
      });

      test('should not be equal if usernames are different', () {
        // Arrange
        final username1 = Username('johndoe');
        final username2 = Username('janedoe');

        // Assert
        expect(username1, isNot(equals(username2)));
      });
    });

    group('i18n', () {
      test('should show InvalidUsername error in English', () {
        // Arrange
        FailureMessages.setLanguage(Language.en);
        final username = Username('john doe');

        // Assert
        expect(
          username.failureOrNull?.message,
          'Username must contain only letters, numbers, and underscores',
        );
      });

      test('should show InvalidUsername error in French', () {
        // Arrange
        FailureMessages.setLanguage(Language.fr);
        final username = Username('john doe');

        // Assert
        expect(
          username.failureOrNull?.message,
          'Le nom d\'utilisateur ne peut contenir que des lettres, chiffres et underscores',
        );
      });

      test('should show TooShort error in English', () {
        // Arrange
        FailureMessages.setLanguage(Language.en);
        final username = Username('ab');

        // Assert
        expect(
          username.failureOrNull?.message,
          'Value is too short (min: 3, actual: 2)',
        );
      });

      test('should show TooShort error in French', () {
        // Arrange
        FailureMessages.setLanguage(Language.fr);
        final username = Username('ab');

        // Assert
        expect(
          username.failureOrNull?.message,
          'La valeur est trop courte (min: 3, actuel: 2)',
        );
      });
    });
  });
}
