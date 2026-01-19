import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'value_failure.dart';

@immutable
abstract class ValueObject<T> extends Equatable {
  const ValueObject();

  /// Gets the value or failure
  Either<ValueFailure, T> get value;

  /// Check if the Value Object is valid
  bool get isValid => value.isRight();

  /// Gets the value or throws an exception if invalid
  T getOrCrash() {
    return value.fold(
      (failure) => throw Exception('ValueObject invalide : ${failure.message}'),
      (valid) => valid,
    );
  }

  /// Gets the value or returns a default value
  T getOrElse(T defaultValue) {
    return value.getOrElse(() => defaultValue);
  }

  /// Returns failure or null if valid
  ValueFailure? get failureOrNull {
    return value.fold((failure) => failure, (_) => null);
  }

  @override
  List<Object?> get props => [value];

  @override
  bool get stringify => true;
}
