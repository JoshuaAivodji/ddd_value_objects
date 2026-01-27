import 'package:ddd_value_objects/src/core/i18n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ddd_value_objects/src/common/url.dart';
import 'package:ddd_value_objects/src/core/failures.dart';

void main() {
  group('Url', () {
    group('Valid URLs', () {
      test('should accept valid HTTP URL', () {
        // Arrange
        final url = Url('http://example.com');

        // Assert
        expect(url.isValid, true);
        expect(url.getOrCrash(), 'http://example.com');
      });

      test('should accept valid HTTPS URL', () {
        // Arrange
        final url = Url('https://example.com');

        // Assert
        expect(url.isValid, true);
        expect(url.getOrCrash(), 'https://example.com');
      });

      test('should accept URL with path', () {
        // Arrange
        final url = Url('https://example.com/page/article');

        // Assert
        expect(url.isValid, true);
        expect(url.getOrCrash(), 'https://example.com/page/article');
      });

      test('should accept URL with query parameters', () {
        // Arrange
        final url = Url('https://example.com?key=value&foo=bar');

        // Assert
        expect(url.isValid, true);
      });

      test('should accept URL with port', () {
        // Arrange
        final url = Url('https://example.com:8080');

        // Assert
        expect(url.isValid, true);
      });

      test('should accept URL with fragment', () {
        // Arrange
        final url = Url('https://example.com#section');

        // Assert
        expect(url.isValid, true);
      });

      test('should accept complete URL', () {
        // Arrange
        final url = Url('https://example.com:8080/path?key=value#section');

        // Assert
        expect(url.isValid, true);
      });

      test('should trim whitespace', () {
        // Arrange
        final url = Url('  https://example.com  ');

        // Assert
        expect(url.isValid, true);
        expect(url.getOrCrash(), 'https://example.com');
      });

      test('should accept URL with subdomain', () {
        // Arrange
        final url = Url('https://api.example.com');

        // Assert
        expect(url.isValid, true);
      });

      test('should accept URL with multiple subdomains', () {
        // Arrange
        final url = Url('https://api.v2.example.com');

        // Assert
        expect(url.isValid, true);
      });
    });

    group('Invalid URLs', () {
      test('should reject empty URL', () {
        // Arrange
        final url = Url('');

        // Assert
        expect(url.isValid, false);
        expect(url.failureOrNull, isA<EmptyValue>());
      });

      test('should reject URL without protocol', () {
        // Arrange
        final url = Url('example.com');

        // Assert
        expect(url.isValid, false);
        expect(url.failureOrNull, isA<MissingProtocol>());
      });

      test('should reject URL with invalid protocol', () {
        // Arrange
        final url = Url('ftp://example.com');

        // Assert
        expect(url.isValid, false);
        expect(url.failureOrNull, isA<InvalidUrl>());
      });

      test('should reject URL without domain', () {
        // Arrange
        final url = Url('https://');

        // Assert
        expect(url.isValid, false);
        expect(url.failureOrNull, isA<InvalidUrl>());
      });

      test('should reject malformed URL', () {
        // Arrange
        final url = Url('ht!tp://invalid');

        // Assert
        expect(url.isValid, false);
        expect(url.failureOrNull, isA<InvalidUrl>());
      });
    });

    group('Helper methods - protocol, domain, path', () {
      test('should extract protocol from HTTP URL', () {
        // Arrange
        final url = Url('http://example.com');

        // Assert
        expect(url.protocol, 'http');
      });

      test('should extract protocol from HTTPS URL', () {
        // Arrange
        final url = Url('https://example.com');

        // Assert
        expect(url.protocol, 'https');
      });

      test('should extract domain', () {
        // Arrange
        final url = Url('https://example.com/path');

        // Assert
        expect(url.domain, 'example.com');
      });

      test('should extract domain with subdomain', () {
        // Arrange
        final url = Url('https://api.example.com');

        // Assert
        expect(url.domain, 'api.example.com');
      });

      test('should extract path', () {
        // Arrange
        final url = Url('https://example.com/page/article');

        // Assert
        expect(url.path, '/page/article');
      });

      test('should return / for root path', () {
        // Arrange
        final url = Url('https://example.com');

        // Assert
        expect(url.path, '/');
      });

      test('should return null for invalid URL', () {
        // Arrange
        final url = Url('invalid');

        // Assert
        expect(url.protocol, null);
        expect(url.domain, null);
        expect(url.path, null);
      });
    });

    group('Helper methods - port and query parameters', () {
      test('should extract custom port', () {
        // Arrange
        final url = Url('https://example.com:8080');

        // Assert
        expect(url.port, 8080);
      });

      test('should return null for default port', () {
        // Arrange
        final url = Url('https://example.com');

        // Assert
        expect(url.port, null);
      });

      test('should extract query parameters', () {
        // Arrange
        final url = Url('https://example.com?key=value&foo=bar');

        // Assert
        expect(url.queryParameters, {'key': 'value', 'foo': 'bar'});
      });

      test('should return null for no query parameters', () {
        // Arrange
        final url = Url('https://example.com');

        // Assert
        expect(url.queryParameters, null);
      });

      test('hasQueryParameters should return true when present', () {
        // Arrange
        final url = Url('https://example.com?key=value');

        // Assert
        expect(url.hasQueryParameters, true);
      });

      test('hasQueryParameters should return false when absent', () {
        // Arrange
        final url = Url('https://example.com');

        // Assert
        expect(url.hasQueryParameters, false);
      });
    });

    group('Helper methods - fragment and security', () {
      test('should extract fragment', () {
        // Arrange
        final url = Url('https://example.com#section');

        // Assert
        expect(url.fragment, 'section');
      });

      test('should return null for no fragment', () {
        // Arrange
        final url = Url('https://example.com');

        // Assert
        expect(url.fragment, null);
      });

      test('hasFragment should return true when present', () {
        // Arrange
        final url = Url('https://example.com#anchor');

        // Assert
        expect(url.hasFragment, true);
      });

      test('hasFragment should return false when absent', () {
        // Arrange
        final url = Url('https://example.com');

        // Assert
        expect(url.hasFragment, false);
      });

      test('isSecure should return true for HTTPS', () {
        // Arrange
        final url = Url('https://example.com');

        // Assert
        expect(url.isSecure, true);
      });

      test('isSecure should return false for HTTP', () {
        // Arrange
        final url = Url('http://example.com');

        // Assert
        expect(url.isSecure, false);
      });

      test('isSecure should return false for invalid URL', () {
        // Arrange
        final url = Url('invalid');

        // Assert
        expect(url.isSecure, false);
      });
    });

    group('Equality', () {
      test('should be equal if URLs are the same', () {
        // Arrange
        final url1 = Url('https://example.com');
        final url2 = Url('https://example.com');

        // Assert
        expect(url1, equals(url2));
      });

      test('should not be equal if URLs are different', () {
        // Arrange
        final url1 = Url('https://example.com');
        final url2 = Url('https://different.com');

        // Assert
        expect(url1, isNot(equals(url2)));
      });

      test('should not be equal if protocols differ', () {
        // Arrange
        final url1 = Url('http://example.com');
        final url2 = Url('https://example.com');

        // Assert
        expect(url1, isNot(equals(url2)));
      });
    });

    group('i18n', () {
      test('should show InvalidUrl error in English', () {
        // Arrange
        FailureMessages.setLanguage(Language.en);
        final url = Url('https://');

        // Assert
        expect(url.failureOrNull?.message, 'Invalid URL format');
      });

      test('should show InvalidUrl error in French', () {
        // Arrange
        FailureMessages.setLanguage(Language.fr);
        final url = Url('https://');

        // Assert
        expect(url.failureOrNull?.message, 'Format d\'URL invalide');
      });

      test('should show MissingProtocol error in English', () {
        // Arrange
        FailureMessages.setLanguage(Language.en);
        final url = Url('example.com');

        // Assert
        expect(
          url.failureOrNull?.message,
          'URL must have a protocol (http:// or https://)',
        );
      });

      test('should show MissingProtocol error in French', () {
        // Arrange
        FailureMessages.setLanguage(Language.fr);
        final url = Url('example.com');

        // Assert
        expect(
          url.failureOrNull?.message,
          'L\'URL doit avoir un protocole (http:// ou https://)',
        );
      });
    });
  });
}
