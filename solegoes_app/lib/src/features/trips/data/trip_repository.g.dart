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
        isAutoDispose: false,
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

String _$tripRepositoryHash() => r'aa5630e98fb3da418ff7582760cf808feb9638fe';

/// Provider for all trips

@ProviderFor(allTrips)
final allTripsProvider = AllTripsProvider._();

/// Provider for all trips

final class AllTripsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Trip>>,
          List<Trip>,
          Stream<List<Trip>>
        >
    with $FutureModifier<List<Trip>>, $StreamProvider<List<Trip>> {
  /// Provider for all trips
  AllTripsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTripsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTripsHash();

  @$internal
  @override
  $StreamProviderElement<List<Trip>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Trip>> create(Ref ref) {
    return allTrips(ref);
  }
}

String _$allTripsHash() => r'4f2f41358e3aa9e75b71f436c6cbcec7e49fefde';

/// Provider for featured trips

@ProviderFor(featuredTrips)
final featuredTripsProvider = FeaturedTripsProvider._();

/// Provider for featured trips

final class FeaturedTripsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Trip>>,
          List<Trip>,
          Stream<List<Trip>>
        >
    with $FutureModifier<List<Trip>>, $StreamProvider<List<Trip>> {
  /// Provider for featured trips
  FeaturedTripsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featuredTripsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featuredTripsHash();

  @$internal
  @override
  $StreamProviderElement<List<Trip>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Trip>> create(Ref ref) {
    return featuredTrips(ref);
  }
}

String _$featuredTripsHash() => r'7b742af44532deeec2357a77d8df6de0fd8a25fa';

/// Provider for trending trips

@ProviderFor(trendingTrips)
final trendingTripsProvider = TrendingTripsProvider._();

/// Provider for trending trips

final class TrendingTripsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Trip>>,
          List<Trip>,
          Stream<List<Trip>>
        >
    with $FutureModifier<List<Trip>>, $StreamProvider<List<Trip>> {
  /// Provider for trending trips
  TrendingTripsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trendingTripsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trendingTripsHash();

  @$internal
  @override
  $StreamProviderElement<List<Trip>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Trip>> create(Ref ref) {
    return trendingTrips(ref);
  }
}

String _$trendingTripsHash() => r'f5a0cfacd7139c2bd90e4f0354872231dee3cfb2';

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

/// Provider for weekend getaways (short trips <= 4 days)

@ProviderFor(weekendGetaways)
final weekendGetawaysProvider = WeekendGetawaysProvider._();

/// Provider for weekend getaways (short trips <= 4 days)

final class WeekendGetawaysProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Trip>>,
          List<Trip>,
          Stream<List<Trip>>
        >
    with $FutureModifier<List<Trip>>, $StreamProvider<List<Trip>> {
  /// Provider for weekend getaways (short trips <= 4 days)
  WeekendGetawaysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weekendGetawaysProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weekendGetawaysHash();

  @$internal
  @override
  $StreamProviderElement<List<Trip>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Trip>> create(Ref ref) {
    return weekendGetaways(ref);
  }
}

String _$weekendGetawaysHash() => r'666e2087476e4d69fcd38dd6e189fdc8a28e1244';
