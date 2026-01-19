class PasswordValidationConfig {
  final int minLength;
  final int? maxLength;
  final bool requireUpperCase;
  final bool requireLowerCase;
  final bool requireDigit;
  final bool requireSpecialCharacter;

  const PasswordValidationConfig({
    this.minLength = 8,
    this.maxLength,
    this.requireUpperCase = true,
    this.requireLowerCase = true,
    this.requireDigit = true,
    this.requireSpecialCharacter = true,
  });

  /// Default configuration (high security)
  static const strong = PasswordValidationConfig();

  /// Average configuration (moderate security)
  static const medium = PasswordValidationConfig(
    minLength: 6,
    requireSpecialCharacter: false,
  );

  /// Low configuration (minimum security)
  static const weak = PasswordValidationConfig(
    minLength: 4,
    requireUpperCase: false,
    requireDigit: false,
    requireSpecialCharacter: false,
  );
}
