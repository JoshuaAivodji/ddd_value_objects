import 'i18n.dart';
import 'value_failure.dart';

class EmptyValue extends ValueFailure {
  const EmptyValue();

  @override
  String get message => FailureMessages.emptyValue;
}

class TooShort extends ValueFailure {
  final int minLength;
  final int actualLength;

  const TooShort({required this.minLength, required this.actualLength});

  @override
  String get message => FailureMessages.tooShort(minLength, actualLength);

  @override
  List<Object?> get props => [minLength, actualLength];
}

class TooLong extends ValueFailure {
  final int maxLength;
  final int actualLength;

  const TooLong({required this.maxLength, required this.actualLength});

  @override
  String get message => FailureMessages.tooLong(maxLength, actualLength);

  @override
  List<Object?> get props => [maxLength, actualLength];
}

class InvalidFormat extends ValueFailure {
  final String fieldName;
  final String? hint;

  const InvalidFormat({required this.fieldName, this.hint});

  @override
  String get message => FailureMessages.invalidFormat(fieldName, hint);

  @override
  List<Object?> get props => [fieldName, hint];
}

class InvalidEmail extends ValueFailure {
  const InvalidEmail();

  @override
  String get message => FailureMessages.invalidEmail;
}

class NoUpperCase extends ValueFailure {
  const NoUpperCase();

  @override
  String get message => FailureMessages.noUpperCase;
}

class NoLowerCase extends ValueFailure {
  const NoLowerCase();

  @override
  String get message => FailureMessages.noLowerCase;
}

class NoDigit extends ValueFailure {
  const NoDigit();

  @override
  String get message => FailureMessages.noDigit;
}

class NoSpecialCharacter extends ValueFailure {
  const NoSpecialCharacter();

  @override
  String get message => FailureMessages.noSpecialCharacter;
}

class InvalidCharacters extends ValueFailure {
  const InvalidCharacters();

  @override
  String get message => FailureMessages.invalidCharacters;
}

class ContainsDigits extends ValueFailure {
  const ContainsDigits();

  @override
  String get message => FailureMessages.containsDigits;
}

class NegativeValue extends ValueFailure {
  const NegativeValue();

  @override
  String get message => FailureMessages.negativeValue;
}

class ExceedsMaximum extends ValueFailure {
  final int maximum;
  final int actualValue;

  const ExceedsMaximum({required this.maximum, required this.actualValue});

  @override
  String get message => FailureMessages.exceedsMaximum(maximum, actualValue);

  @override
  List<Object?> get props => [maximum, actualValue];
}

class BelowMinimum extends ValueFailure {
  final int minimum;
  final int actualValue;

  const BelowMinimum({required this.minimum, required this.actualValue});

  @override
  String get message => FailureMessages.belowMinimum(minimum, actualValue);

  @override
  List<Object?> get props => [minimum, actualValue];
}
