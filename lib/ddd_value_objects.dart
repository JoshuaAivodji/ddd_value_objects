// Core
export 'src/core/value_object.dart';
export 'src/core/value_failure.dart';
export 'src/core/failures.dart';
export 'src/core/i18n.dart';

// Common Value Objects
export 'src/common/email_address.dart';
export 'src/common/password.dart';
export 'src/common/name.dart';
export 'src/common/age.dart';

// Re-export Either from dartz for convenience
export 'package:dartz/dartz.dart' show Either, Left, Right, left, right;
