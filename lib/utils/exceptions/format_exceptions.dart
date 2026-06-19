class GFormatException implements Exception {
  final String message;

  const GFormatException([this.message = 'An unexpected format error occurred. Please check your input.']);

  factory GFormatException.fromMessage(String message) {
    return GFormatException(message);
  }

  String get formattedMessage => message;

  factory GFormatException.fromCode(String code) {
    switch (code) {
      case 'invalid-email-format':
        return const GFormatException('Email address format is invalid. Please enter a valid email.');
      case 'invalid-date-format':
        return const GFormatException('Date format is invalid. Please enter a valid date.');
      case 'invalid-url-format':
        return const GFormatException('URL format is invalid. Please enter a valid URL.');
      case 'invalid-numeric-format':
        return const GFormatException('Input should be in a valid numeric format.');
      default:
        return const GFormatException('A formatting error has occurred. Please try again.');
    }
  }
}