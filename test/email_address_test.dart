import 'package:ddd_value_objects/src/core/failures.dart';
import 'package:ddd_value_objects/src/core/i18n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ddd_value_objects/src/common/email_address.dart';

void main() {
  group('EmailAddress', () {
    group('Valid emails', () {
      test('should accept valid email with lowercase', () {
        // Arrange
        final email = EmailAddress('test@example.com');

        // Assert
        expect(email.isValid, true);
        expect(email.getOrCrash(), 'test@example.com');
      });

      test('should normalize email to lowercase', () {
        // Arrange
        final email = EmailAddress('Test@Example.COM');

        // Assert
        expect(email.isValid, true);
        expect(email.getOrCrash(), 'test@example.com');
      });

      test('should trim whitespace', () {
        // Arrange
        final email = EmailAddress('  test@example.com  ');

        // Assert
        expect(email.isValid, true);
        expect(email.getOrCrash(), 'test@example.com');
      });

      test('should accept email with plus sign', () {
        // Arrange
        final email = EmailAddress('test+tag@example.com');

        // Assert
        expect(email.isValid, true);
        expect(email.getOrCrash(), 'test+tag@example.com');
      });

      test('should accept email with numbers', () {
        // Arrange
        final email = EmailAddress('user123@example456.com');

        // Assert
        expect(email.isValid, true);
      });

      test('should accept email with dots in local part', () {
        // Arrange
        final email = EmailAddress('first.last@example.com');

        // Assert
        expect(email.isValid, true);
      });
    });

    group('Invalid emails', () {
      test('should reject empty email', () {
        // Arrange
        final email = EmailAddress('');

        // Assert
        expect(email.isValid, false);
        expect(email.failureOrNull, isA<EmptyValue>());
      });

      test('should reject email without @', () {
        // Arrange
        final email = EmailAddress('testexample.com');

        // Assert
        expect(email.isValid, false);
        expect(email.failureOrNull, isA<InvalidEmail>());
      });

      test('should reject email without domain', () {
        // Arrange
        final email = EmailAddress('test@');

        // Assert
        expect(email.isValid, false);
        expect(email.failureOrNull, isA<InvalidEmail>());
      });

      test('should reject email without local part', () {
        // Arrange
        final email = EmailAddress('@example.com');

        // Assert
        expect(email.isValid, false);
        expect(email.failureOrNull, isA<InvalidEmail>());
      });

      test('should reject email without TLD', () {
        // Arrange
        final email = EmailAddress('test@example');

        // Assert
        expect(email.isValid, false);
        expect(email.failureOrNull, isA<InvalidEmail>());
      });

      test('should reject email with spaces', () {
        // Arrange
        final email = EmailAddress('test @example.com');

        // Assert
        expect(email.isValid, false);
        expect(email.failureOrNull, isA<InvalidEmail>());
      });

      test('should reject email with multiple @', () {
        // Arrange
        final email = EmailAddress('test@@example.com');

        // Assert
        expect(email.isValid, false);
        expect(email.failureOrNull, isA<InvalidEmail>());
      });
    });

    group('Helper methods', () {
      test('should extract domain correctly', () {
        // Arrange
        final email = EmailAddress('test@example.com');

        // Assert
        expect(email.domain, 'example.com');
      });

      test('should extract local part correctly', () {
        // Arrange
        final email = EmailAddress('test@example.com');

        // Assert
        expect(email.localPart, 'test');
      });

      test('should return null domain for invalid email', () {
        // Arrange
        final email = EmailAddress('invalid-email');

        // Assert
        expect(email.domain, null);
      });

      test('should return null local part for invalid email', () {
        // Arrange
        final email = EmailAddress('invalid-email');

        // Assert
        expect(email.localPart, null);
      });

      test('getOrElse should return default value for invalid email', () {
        // Arrange
        final email = EmailAddress('invalid');

        // Assert
        expect(email.getOrElse('default@example.com'), 'default@example.com');
      });

      test('getOrCrash should throw for invalid email', () {
        // Arrange
        final email = EmailAddress('invalid');

        // Assert
        expect(() => email.getOrCrash(), throwsException);
      });
    });

    group('Equality', () {
      test('should be equal if emails are the same', () {
        // Arrange
        final email1 = EmailAddress('test@example.com');
        final email2 = EmailAddress('test@example.com');

        // Assert
        expect(email1, equals(email2));
      });

      test('should be equal after normalization', () {
        // Arrange
        final email1 = EmailAddress('Test@Example.com');
        final email2 = EmailAddress('test@example.com');

        // Assert
        expect(email1, equals(email2));
      });

      test('should not be equal if emails are different', () {
        // Arrange
        final email1 = EmailAddress('test1@example.com');
        final email2 = EmailAddress('test2@example.com');

        // Assert
        expect(email1, isNot(equals(email2)));
      });
    });

    group('i18n', () {
      test('should show error message in English', () {
        // Arrange
        FailureMessages.setLanguage(Language.en);
        final email = EmailAddress('invalid');

        // Assert
        expect(email.failureOrNull?.message, 'Invalid email address');
      });

      test('should show error message in French', () {
        // Arrange
        FailureMessages.setLanguage(Language.fr);
        final email = EmailAddress('invalid');

        // Assert
        expect(email.failureOrNull?.message, 'Adresse email invalide');
      });

      test('should show empty value error in English', () {
        // Arrange
        FailureMessages.setLanguage(Language.en);
        final email = EmailAddress('');

        // Assert
        expect(email.failureOrNull?.message, 'Value cannot be empty');
      });

      test('should show empty value error in French', () {
        // Arrange
        FailureMessages.setLanguage(Language.fr);
        final email = EmailAddress('');

        // Assert
        expect(email.failureOrNull?.message, 'La valeur ne peut pas être vide');
      });
    });
  });

  group('Helper methods - isDisposable and isBusinessEmail', () {
    test('should detect disposable email domains', () {
      // Arrange
      final emails = [
        EmailAddress('test@tempmail.com'),
        EmailAddress('user@10minutemail.com'),
        EmailAddress('fake@mailinator.com'),
        EmailAddress('temp@guerrillamail.com'),
      ];

      // Assert
      for (final email in emails) {
        expect(
          email.isDisposable,
          true,
          reason: '${email.domain} should be disposable',
        );
      }
    });

    test('should not detect regular emails as disposable', () {
      // Arrange
      final emails = [
        EmailAddress('test@gmail.com'),
        EmailAddress('user@company.com'),
        EmailAddress('admin@mycorp.io'),
      ];

      // Assert
      for (final email in emails) {
        expect(
          email.isDisposable,
          false,
          reason: '${email.domain} should not be disposable',
        );
      }
    });

    test('should return false for disposable check on invalid email', () {
      // Arrange
      final email = EmailAddress('invalid-email');

      // Assert
      expect(email.isDisposable, false);
    });

    test('should detect personal email domains', () {
      // Arrange
      final emails = [
        EmailAddress('test@gmail.com'),
        EmailAddress('user@yahoo.com'),
        EmailAddress('admin@hotmail.com'),
        EmailAddress('contact@outlook.com'),
        EmailAddress('hello@icloud.com'),
      ];

      // Assert
      for (final email in emails) {
        expect(
          email.isBusinessEmail,
          false,
          reason: '${email.domain} should be personal',
        );
      }
    });

    test('should detect business email domains', () {
      // Arrange
      final emails = [
        EmailAddress('contact@mycompany.com'),
        EmailAddress('info@startup.io'),
        EmailAddress('admin@enterprise.net'),
        EmailAddress('support@business.co'),
      ];

      // Assert
      for (final email in emails) {
        expect(
          email.isBusinessEmail,
          true,
          reason: '${email.domain} should be business',
        );
      }
    });

    test('should handle case insensitivity for business email check', () {
      // Arrange
      final email1 = EmailAddress('test@GMAIL.COM');
      final email2 = EmailAddress('test@Gmail.Com');

      // Assert
      expect(email1.isBusinessEmail, false);
      expect(email2.isBusinessEmail, false);
    });

    test('should return false for business email check on invalid email', () {
      // Arrange
      final email = EmailAddress('invalid-email');

      // Assert
      expect(email.isBusinessEmail, false);
    });
  });
}
