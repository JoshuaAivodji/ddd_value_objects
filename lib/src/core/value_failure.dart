import 'package:equatable/equatable.dart';

abstract class ValueFailure extends Equatable {
  const ValueFailure();

  /// Readable error message
  String get message;

  @override
  List<Object?> get props => [message];
}
