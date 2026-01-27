import 'package:dartz/dartz.dart';
import '../core/value_object.dart';
import '../core/value_failure.dart';
import '../core/failures.dart';

class Url extends ValueObject<String> {
  @override
  final Either<ValueFailure, String> value;

  factory Url(String input) {
    return Url._(_validate(input));
  }

  const Url._(this.value);

  static Either<ValueFailure, String> _validate(String input) {
    if (input.trim().isEmpty) {
      return left(const EmptyValue());
    }

    final trimmed = input.trim();

    Uri? uri;
    try {
      uri = Uri.parse(trimmed);
    } catch (e) {
      return left(const InvalidUrl());
    }

    // Verify that the URL has a protocol
    if (!uri.hasScheme) {
      return left(const MissingProtocol());
    }

    // Verify that the protocol is http or https
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return left(const InvalidUrl());
    }

    // Check that there is a host
    if (uri.host.isEmpty) {
      return left(const InvalidUrl());
    }

    return right(trimmed);
  }

  String? get protocol {
    return value.fold((_) => null, (url) => Uri.parse(url).scheme);
  }

  String? get domain {
    return value.fold((_) => null, (url) => Uri.parse(url).host);
  }

  String? get path {
    return value.fold((_) => null, (url) {
      final uri = Uri.parse(url);
      return uri.path.isEmpty ? '/' : uri.path;
    });
  }

  int? get port {
    return value.fold((_) => null, (url) {
      final uri = Uri.parse(url);
      return uri.hasPort ? uri.port : null;
    });
  }

  Map<String, String>? get queryParameters {
    return value.fold((_) => null, (url) {
      final uri = Uri.parse(url);
      return uri.queryParameters.isEmpty ? null : uri.queryParameters;
    });
  }

  // Check if the URL uses HTTPS
  bool get isSecure {
    return value.fold((_) => false, (url) => Uri.parse(url).scheme == 'https');
  }

  // Check if the URL has query parameters
  bool get hasQueryParameters {
    return value.fold(
      (_) => false,
      (url) => Uri.parse(url).queryParameters.isNotEmpty,
    );
  }

  // Check if the URL has a fragment (#anchor)
  bool get hasFragment {
    return value.fold(
      (_) => false,
      (url) => Uri.parse(url).fragment.isNotEmpty,
    );
  }

  // Gets the fragment (part after #)
  String? get fragment {
    return value.fold((_) => null, (url) {
      final frag = Uri.parse(url).fragment;
      return frag.isEmpty ? null : frag;
    });
  }
}
