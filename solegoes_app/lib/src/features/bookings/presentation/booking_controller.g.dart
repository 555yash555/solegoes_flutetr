// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for managing booking operations
/// Handles booking creation with AsyncValue for consistent error handling

@ProviderFor(BookingController)
final bookingControllerProvider = BookingControllerProvider._();

/// Controller for managing booking operations
/// Handles booking creation with AsyncValue for consistent error handling
final class BookingControllerProvider
    extends $AsyncNotifierProvider<BookingController, void> {
  /// Controller for managing booking operations
  /// Handles booking creation with AsyncValue for consistent error handling
  BookingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingControllerHash();

  @$internal
  @override
  BookingController create() => BookingController();
}

String _$bookingControllerHash() => r'18d33467f02c55f7be4ad257e352cd0762848df7';

/// Controller for managing booking operations
/// Handles booking creation with AsyncValue for consistent error handling

abstract class _$BookingController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
