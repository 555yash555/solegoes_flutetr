// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for SharedPreferences instance

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Provider for SharedPreferences instance

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// Provider for SharedPreferences instance
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'd22b545aefe95500327f9dce52c645d746349271';

/// Provider for OnboardingRepository

@ProviderFor(onboardingRepository)
final onboardingRepositoryProvider = OnboardingRepositoryProvider._();

/// Provider for OnboardingRepository

final class OnboardingRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<OnboardingRepository>,
          OnboardingRepository,
          FutureOr<OnboardingRepository>
        >
    with
        $FutureModifier<OnboardingRepository>,
        $FutureProvider<OnboardingRepository> {
  /// Provider for OnboardingRepository
  OnboardingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<OnboardingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OnboardingRepository> create(Ref ref) {
    return onboardingRepository(ref);
  }
}

String _$onboardingRepositoryHash() =>
    r'a107d6dee0664257bf58e1945f5436e7e8c3590c';

/// Provider to check if onboarding is complete (sync access after init)

@ProviderFor(isOnboardingComplete)
final isOnboardingCompleteProvider = IsOnboardingCompleteProvider._();

/// Provider to check if onboarding is complete (sync access after init)

final class IsOnboardingCompleteProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider to check if onboarding is complete (sync access after init)
  IsOnboardingCompleteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOnboardingCompleteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOnboardingCompleteHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isOnboardingComplete(ref);
  }
}

String _$isOnboardingCompleteHash() =>
    r'bf2e8d841d2fcbc285189f361b2eb12f0771f780';
