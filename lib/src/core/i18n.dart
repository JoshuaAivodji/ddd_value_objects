enum Language { en, fr }

class FailureMessages {
  static Language _currentLanguage = Language.en;

  static void setLanguage(Language language) {
    _currentLanguage = language;
  }

  static Language get currentLanguage => _currentLanguage;

  // Messages for EmptyValue
  static String get emptyValue {
    switch (_currentLanguage) {
      case Language.en:
        return 'Value cannot be empty';
      case Language.fr:
        return 'La valeur ne peut pas être vide';
    }
  }

  // Messages for TooShort
  static String tooShort(int minLength, int actualLength) {
    switch (_currentLanguage) {
      case Language.en:
        return 'Value is too short (min: $minLength, actual: $actualLength)';
      case Language.fr:
        return 'La valeur est trop courte (min: $minLength, actuel: $actualLength)';
    }
  }

  // Messages for TooLong
  static String tooLong(int maxLength, int actualLength) {
    switch (_currentLanguage) {
      case Language.en:
        return 'Value is too long (max: $maxLength, actual: $actualLength)';
      case Language.fr:
        return 'La valeur est trop longue (max: $maxLength, actuel: $actualLength)';
    }
  }

  // Messages for InvalidFormat
  static String invalidFormat(String fieldName, String? hint) {
    final hintText = hint != null ? ' ($hint)' : '';
    switch (_currentLanguage) {
      case Language.en:
        return 'Invalid format for $fieldName$hintText';
      case Language.fr:
        return 'Format invalide pour $fieldName$hintText';
    }
  }

  // Messages for InvalidEmail
  static String get invalidEmail {
    switch (_currentLanguage) {
      case Language.en:
        return 'Invalid email address';
      case Language.fr:
        return 'Adresse email invalide';
    }
  }

  // Messages for NoUpperCase
  static String get noUpperCase {
    switch (_currentLanguage) {
      case Language.en:
        return 'Password must contain at least one uppercase letter';
      case Language.fr:
        return 'Le mot de passe doit contenir au moins une majuscule';
    }
  }

  // Messages for NoLowerCase
  static String get noLowerCase {
    switch (_currentLanguage) {
      case Language.en:
        return 'Password must contain at least one lowercase letter';
      case Language.fr:
        return 'Le mot de passe doit contenir au moins une minuscule';
    }
  }

  // Messages for NoDigit
  static String get noDigit {
    switch (_currentLanguage) {
      case Language.en:
        return 'Password must contain at least one digit';
      case Language.fr:
        return 'Le mot de passe doit contenir au moins un chiffre';
    }
  }

  // Messages for NoSpecialCharacter
  static String get noSpecialCharacter {
    switch (_currentLanguage) {
      case Language.en:
        return 'Password must contain at least one special character';
      case Language.fr:
        return 'Le mot de passe doit contenir au moins un caractère spécial';
    }
  }

  // Messages for InvalidCharacters
  static String get invalidCharacters {
    switch (_currentLanguage) {
      case Language.en:
        return 'Name contains invalid characters';
      case Language.fr:
        return 'Le nom contient des caractères invalides';
    }
  }

  // Messages for ContainsDigits
  static String get containsDigits {
    switch (_currentLanguage) {
      case Language.en:
        return 'Name cannot contain digits';
      case Language.fr:
        return 'Le nom ne peut pas contenir de chiffres';
    }
  }

  // Messages for NegativeValue
  static String get negativeValue {
    switch (_currentLanguage) {
      case Language.en:
        return 'Value cannot be negative';
      case Language.fr:
        return 'La valeur ne peut pas être négative';
    }
  }

  // Messages for ExceedsMaximum
  static String exceedsMaximum(int maximum, int actualValue) {
    switch (_currentLanguage) {
      case Language.en:
        return 'Value exceeds maximum (max: $maximum, actual: $actualValue)';
      case Language.fr:
        return 'La valeur dépasse le maximum (max: $maximum, actuel: $actualValue)';
    }
  }

  // Messages for BelowMinimum
  static String belowMinimum(int minimum, int actualValue) {
    switch (_currentLanguage) {
      case Language.en:
        return 'Value is below minimum (min: $minimum, actual: $actualValue)';
      case Language.fr:
        return 'La valeur est en dessous du minimum (min: $minimum, actuel: $actualValue)';
    }
  }

  // Messages for InvalidUrl
  static String get invalidUrl {
    switch (_currentLanguage) {
      case Language.en:
        return 'Invalid URL format';
      case Language.fr:
        return 'Format d\'URL invalide';
    }
  }

  // Messages for MissingProtocol
  static String get missingProtocol {
    switch (_currentLanguage) {
      case Language.en:
        return 'URL must have a protocol (http:// or https://)';
      case Language.fr:
        return 'L\'URL doit avoir un protocole (http:// ou https://)';
    }
  }

  // Messages for InvalidUsername
  static String get invalidUsername {
    switch (_currentLanguage) {
      case Language.en:
        return 'Username must contain only letters, numbers, and underscores';
      case Language.fr:
        return 'Le nom d\'utilisateur ne peut contenir que des lettres, chiffres et underscores';
    }
  }
}
