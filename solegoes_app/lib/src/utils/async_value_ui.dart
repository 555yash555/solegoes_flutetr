import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_widgets/app_snackbar.dart';
import 'app_exception.dart';

/// Extension on AsyncValue to show user-friendly error messages.
///
/// Usage:
/// ```dart
/// ref.listen(authControllerProvider, (prev, next) {
///   next.showSnackbarOnError(context);
/// });
/// ```
extension AsyncValueUI on AsyncValue {
  /// Shows a styled error snackbar when AsyncValue has an error.
  /// Automatically converts Firebase errors to user-friendly messages.
  void showSnackbarOnError(BuildContext context) {
    if (!isLoading && hasError) {
      final exception = AppException.fromError(error);
      AppSnackbar.showError(context, exception.message);
    }
  }

  /// Shows a styled success snackbar.
  /// Call this after a successful operation.
  void showSnackbarOnSuccess(BuildContext context, String message) {
    if (!isLoading && !hasError && hasValue) {
      AppSnackbar.showSuccess(context, message);
    }
  }
}

/// Extension specifically for `AsyncValue<void>` (common for mutations)
extension AsyncValueVoidUI on AsyncValue<void> {
  /// Check if the operation completed successfully (not loading, no error, has value)
  bool get isSuccess => !isLoading && !hasError && hasValue;
}
