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
}
