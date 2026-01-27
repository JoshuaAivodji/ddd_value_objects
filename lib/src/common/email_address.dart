import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../core/value_object.dart';
import '../core/value_failure.dart';

class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure, String> value;

  factory EmailAddress(String input) {
    return EmailAddress._(_validate(input));
  }

  const EmailAddress._(this.value);

  static Either<ValueFailure, String> _validate(String input) {
    if (input.isEmpty) {
      return left(const EmptyValue());
    }

    const emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

    if (RegExp(emailRegex).hasMatch(input.trim())) {
      return right(input.trim().toLowerCase());
    } else {
      return left(const InvalidEmail());
    }
  }

  // Example: for “test@example.com,” returns “example.com”
  String? get domain {
    return value.fold((_) => null, (email) => email.split('@').last);
  }

  // Example: for “test@example.com,” returns “test”
  String? get localPart {
    return value.fold((_) => null, (email) => email.split('@').first);
  }

  // Check if the email is a disposable/temporary email
  bool get isDisposable {
    return value.fold((_) => false, (email) {
      final disposableDomains = {
        'tempmail.com',
        'temp-mail.org',
        'guerrillamail.com',
        '10minutemail.com',
        'mailinator.com',
        'throwaway.email',
        'sharklasers.com',
        'spam4.me',
        'maildrop.cc',
        'yopmail.com',
        'trashmail.com',
        'getnada.com',
        'mintemail.com',
        'tmpmail.net',
        'fakeinbox.com',
      };

      final emailDomain = domain?.toLowerCase();
      return emailDomain != null && disposableDomains.contains(emailDomain);
    });
  }

  // Check whether the email is a professional/personal email
  bool get isBusinessEmail {
    return value.fold((_) => false, (email) {
      final personalDomains = {
        'gmail.com',
        'yahoo.com',
        'yahoo.fr',
        'hotmail.com',
        'hotmail.fr',
        'outlook.com',
        'outlook.fr',
        'live.com',
        'live.fr',
        'icloud.com',
        'me.com',
        'aol.com',
        'protonmail.com',
        'proton.me',
        'mail.com',
        'zoho.com',
        'yandex.com',
        'gmx.com',
        'gmx.fr',
      };

      final emailDomain = domain?.toLowerCase();
      if (emailDomain == null) return false;

      return !personalDomains.contains(emailDomain);
    });
  }
}
