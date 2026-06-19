class GFirebaseAuthException implements Exception {
  final String code;

  GFirebaseAuthException(this.code);

  String get message{
    switch (code) {
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid login details.';
      case 'email-already-in-use':
        return 'Email address is already registered. Please use a different email.';
      case 'email-already-exists':
        return 'Email address is already registered. Please use a different email.';
      case 'invalid-email': 
        return 'Email address is invalid. Please enter a valid email.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'user-token-revoked':
        return 'The user\'s token has been revoked. Please sign in again.';
      default:
        return 'A Firebase Authentication error has occurred. Please try again.';
    }
  }
}