// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'razorpay_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for RazorpayService
/// This ensures the service is automatically disposed (cleaning up listeners)
/// when the UI consuming it is closed.

@ProviderFor(razorpayService)
final razorpayServiceProvider = RazorpayServiceProvider._();

/// Provider for RazorpayService
/// This ensures the service is automatically disposed (cleaning up listeners)
/// when the UI consuming it is closed.

final class RazorpayServiceProvider
    extends
        $FunctionalProvider<RazorpayService, RazorpayService, RazorpayService>
    with $Provider<RazorpayService> {
  /// Provider for RazorpayService
  /// This ensures the service is automatically disposed (cleaning up listeners)
  /// when the UI consuming it is closed.
  RazorpayServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'razorpayServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$razorpayServiceHash();

  @$internal
  @override
  $ProviderElement<RazorpayService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RazorpayService create(Ref ref) {
    return razorpayService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RazorpayService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RazorpayService>(value),
    );
  }
}

String _$razorpayServiceHash() => r'2bc0d72e45dea2419d7fc29fb865f7ea01071bec';
