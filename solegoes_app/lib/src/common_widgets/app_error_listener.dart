import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/shared/global_error_controller.dart';
import '../utils/app_exception.dart';
import 'app_snackbar.dart';

class AppErrorListener extends ConsumerWidget {
  final Widget child;

  const AppErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Object?>(globalErrorProvider, (previous, next) {
      if (next != null) {
        final message = AppException.fromError(next).message;
        AppSnackbar.showError(context, message);
      }
    });

    return child;
  }
}
