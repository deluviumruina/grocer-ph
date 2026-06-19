class GFirebaseException implements Exception {
  final String code;

  GFirebaseException(this.code);

  String get message {
    switch (code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'The server is currently unavailable. Please try again later.';
      case 'user-not-found':
        return 'No user found for the given email or UID.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Invalid login credentials.';
      case 'session-cookie-expired':
        return 'Session expired. Please sign in again.';
      case 'user-token-expired':
        return 'The user\'s token has expired. Please sign in again.';
      case 'email-already-in-use':
        return 'Email address already registered. Please use a different email.';
      case 'invalid-email':
        return 'Email address is invalid. Please enter a valid email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different user account.';
      case 'internal-error':
        return 'An internal authentication error has occurred. Please try again.';
      case 'unknown':
        return 'An unknown Firebase error has occurred. Please try again.';
      default:
        return 'A Firebase error has occurred. Please try again.';
    }
  }
}