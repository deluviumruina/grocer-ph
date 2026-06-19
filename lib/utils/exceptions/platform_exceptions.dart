class GPlatformException implements Exception {
  final String code;

  GPlatformException(this.code);

  String get message {
    switch (code) {
      case 'device_not_supported':
        return 'This feature is not supported on your device.';
      case 'network_error':
        return 'Network error. Please check your internet connection.';
      case 'network-request-failed':
        return 'Network request failed. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'INVALID-LOGIN-CREDENTIALS':
        return 'Invalid login credentials. Please try again.';
      case 'invalid-password':
        return 'Incorrect password. Please try again.';
      case 'sign_in_failed':
        return 'Sign in failed. Please try again.';
      case 'session-cookie-expired':
        return 'Session has expired. Please sign in again.';
      case 'internal-error':
        return 'Internal error. Please try again later.';
      default:
        return 'A platform error occurred. Please try again.';
    }
  }
}