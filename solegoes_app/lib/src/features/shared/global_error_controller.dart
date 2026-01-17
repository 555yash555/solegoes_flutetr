import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalErrorController extends Notifier<Object?> {
  @override
  Object? build() => null;

  void setException(Object error) {
    state = error;
  }
}

final globalErrorProvider = NotifierProvider<GlobalErrorController, Object?>(GlobalErrorController.new);
