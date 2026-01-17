import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Custom exception that wraps all errors with user-friendly messages.
///
/// Usage:
/// ```dart
/// try {
///   await someFirebaseOperation();
/// } catch (e) {
///   final exception = AppException.fromError(e);
///   showError(exception.message); // Shows friendly message
/// }
/// ```
class AppException implements Exception {
  /// User-friendly message to display
  final String message;

  /// Error code for logging/debugging
  final String? code;

  /// Original error for debugging
  final dynamic originalError;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
  });

  /// Factory to convert any error to AppException with friendly message
  factory AppException.fromError(dynamic error) {
    // Firebase Auth errors
    if (error is FirebaseAuthException) {
      return AppException(
        _mapFirebaseAuthError(error.code),
        code: error.code,
        originalError: error,
      );
    }

    // Razorpay errors
    if (error is PaymentFailureResponse) {
      return AppException(
        _mapRazorpayError(error.code, error.message),
        code: error.code?.toString(),
        originalError: error,
      );
    }

    // General Firebase errors
    if (error is FirebaseException) {
      return AppException(
        _mapFirebaseError(error.code),
        code: error.code,
        originalError: error,
      );
    }

    // AppException passed through
    if (error is AppException) {
      return error;
    }

    // String error
    if (error is String) {
      return AppException(error);
    }

    // Unknown error
    return AppException(
      'Something went wrong. Please try again.',
      originalError: error,
    );
  }

  /// Maps Firebase Auth error codes to user-friendly messages
  static String _mapFirebaseAuthError(String code) {
    switch (code) {
      // Email/Password errors
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password. Please try again';
      case 'invalid-credential':
        return 'Invalid email or password';

      // Registration errors
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';

      // Network/Rate limiting
      case 'network-request-failed':
        return 'No internet connection. Please check your network';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'channel-error':
        return 'Connection error. Please try again';

      // OTP/Verification errors
      case 'invalid-verification-code':
        return 'Invalid verification code. Please try again';
      case 'invalid-verification-id':
        return 'Verification expired. Please request a new code';
      case 'session-expired':
        return 'Session expired. Please start over';

      // Account errors
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method';
      case 'requires-recent-login':
        return 'Please sign in again to continue';

      // Google Sign-In specific
      case 'sign_in_canceled':
        return 'Sign in was cancelled';
      case 'popup-closed-by-user':
        return 'Sign in was cancelled';

      default:
        return 'Authentication failed. Please try again';
    }
  }

  /// Maps general Firebase error codes to user-friendly messages
  static String _mapFirebaseError(String? code) {
    switch (code) {
      case 'permission-denied':
        return 'You don\'t have permission for this action';
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again';
      case 'not-found':
        return 'The requested data was not found';
      case 'already-exists':
        return 'This item already exists';
      case 'resource-exhausted':
        return 'Too many requests. Please try again later';
      case 'cancelled':
        return 'Operation was cancelled';
      case 'data-loss':
        return 'Data could not be saved. Please try again';
      case 'unauthenticated':
        return 'Please sign in to continue';
      default:
        return 'Something went wrong. Please try again';
    }
  }

  /// Maps Razorpay error codes to user-friendly messages
  static String _mapRazorpayError(int? code, String? message) {
    switch (code) {
      case Razorpay.NETWORK_ERROR:
        return 'Network error. Please check your internet connection and try again.';
      case Razorpay.INVALID_OPTIONS:
        return 'Payment configuration error. Please contact support.';
      case Razorpay.TLS_ERROR:
        return 'Your device does not support secure payment. Please update your device.';
      case Razorpay.PAYMENT_CANCELLED:
        return 'Payment was cancelled by user.';
      case Razorpay.UNKNOWN_ERROR:
        return 'An unexpected payment error occurred. Please try again.';
      default:
        return message ?? 'Payment failed. Please try again.';
    }
  }

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Common error messages for reuse
class ErrorMessages {
  ErrorMessages._();

  static const String noInternet = 'No internet connection. Please check your network';
  static const String genericError = 'Something went wrong. Please try again';
  static const String sessionExpired = 'Your session has expired. Please sign in again';
  static const String permissionDenied = 'You don\'t have permission for this action';
  static const String notFound = 'The requested item was not found';
}
