// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for TripRepository

@ProviderFor(tripRepository)
final tripRepositoryProvider = TripRepositoryProvider._();

/// Provider for TripRepository

final class TripRepositoryProvider
    extends $FunctionalProvider<TripRepository, TripRepository, TripRepository>
    with $Provider<TripRepository> {
  /// Provider for TripRepository
  TripRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripRepositoryHash();

  @$internal
  @override
  $ProviderElement<TripRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TripRepository create(Ref ref) {
    return tripRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripRepository>(value),
    );
  }
}

String _$tripRepositoryHash() => r'2696c54918f21f48b07fb71b95947854dc9067e8';

/// Provider for all trips

@ProviderFor(allTrips)
final allTripsProvider = AllTripsProvider._();

/// Provider for all trips

final class AllTripsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Trip>>,
          List<Trip>,
          FutureOr<List<Trip>>
        >
    with $FutureModifier<List<Trip>>, $FutureProvider<List<Trip>> {
  /// Provider for all trips
  AllTripsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTripsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTripsHash();

  @$internal
  @override
  $FutureProviderElement<List<Trip>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Trip>> create(Ref ref) {
    return allTrips(ref);
  }
}

String _$allTripsHash() => r'e8107a573fb3ca3f5ba96b0b68d922e0ed90b3eb';

/// Provider for featured trips

@ProviderFor(featuredTrips)
final featuredTripsProvider = FeaturedTripsProvider._();

/// Provider for featured trips

final class FeaturedTripsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Trip>>,
          List<Trip>,
          FutureOr<List<Trip>>
        >
    with $FutureModifier<List<Trip>>, $FutureProvider<List<Trip>> {
  /// Provider for featured trips
  FeaturedTripsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featuredTripsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featuredTripsHash();

  @$internal
  @override
  $FutureProviderElement<List<Trip>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Trip>> create(Ref ref) {
    return featuredTrips(ref);
  }
}

String _$featuredTripsHash() => r'f59d702cca1f5e21ea6505926079c10594a40485';

/// Provider for trending trips

@ProviderFor(trendingTrips)
final trendingTripsProvider = TrendingTripsProvider._();

/// Provider for trending trips

final class TrendingTripsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Trip>>,
          List<Trip>,
          FutureOr<List<Trip>>
        >
    with $FutureModifier<List<Trip>>, $FutureProvider<List<Trip>> {
  /// Provider for trending trips
  TrendingTripsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trendingTripsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trendingTripsHash();

  @$internal
  @override
  $FutureProviderElement<List<Trip>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Trip>> create(Ref ref) {
    return trendingTrips(ref);
  }
}

String _$trendingTripsHash() => r'ad0f640eb57bf7779ee75a9476238051997f4532';

/// Provider for a specific trip

@ProviderFor(trip)
final tripProvider = TripFamily._();

/// Provider for a specific trip

final class TripProvider
    extends $FunctionalProvider<AsyncValue<Trip?>, Trip?, FutureOr<Trip?>>
    with $FutureModifier<Trip?>, $FutureProvider<Trip?> {
  /// Provider for a specific trip
  TripProvider._({
    required TripFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tripProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tripHash();

  @override
  String toString() {
    return r'tripProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Trip?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Trip?> create(Ref ref) {
    final argument = this.argument as String;
    return trip(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TripProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tripHash() => r'f172ba89da994bf33daa97ba84799b0a4690af8a';

/// Provider for a specific trip

final class TripFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Trip?>, String> {
  TripFamily._()
    : super(
        retry: null,
        name: r'tripProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a specific trip

  TripProvider call(String tripId) =>
      TripProvider._(argument: tripId, from: this);

  @override
  String toString() => r'tripProvider';
}
