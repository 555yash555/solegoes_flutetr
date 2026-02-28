// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agency_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(agencyRepository)
final agencyRepositoryProvider = AgencyRepositoryProvider._();

final class AgencyRepositoryProvider
    extends
        $FunctionalProvider<
          AgencyRepository,
          AgencyRepository,
          AgencyRepository
        >
    with $Provider<AgencyRepository> {
  AgencyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agencyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agencyRepositoryHash();

  @$internal
  @override
  $ProviderElement<AgencyRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AgencyRepository create(Ref ref) {
    return agencyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AgencyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AgencyRepository>(value),
    );
  }
}

String _$agencyRepositoryHash() => r'5cd57ca73d16121b9f75466992d3b8df550400ca';

/// Watches a single agency doc in real time.

@ProviderFor(agencyStream)
final agencyStreamProvider = AgencyStreamFamily._();

/// Watches a single agency doc in real time.

final class AgencyStreamProvider
    extends $FunctionalProvider<AsyncValue<Agency>, Agency, Stream<Agency>>
    with $FutureModifier<Agency>, $StreamProvider<Agency> {
  /// Watches a single agency doc in real time.
  AgencyStreamProvider._({
    required AgencyStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'agencyStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$agencyStreamHash();

  @override
  String toString() {
    return r'agencyStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Agency> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Agency> create(Ref ref) {
    final argument = this.argument as String;
    return agencyStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AgencyStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$agencyStreamHash() => r'f92559dd5ad70938221d3fa79cf18c248b7f46a3';

/// Watches a single agency doc in real time.

final class AgencyStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Agency>, String> {
  AgencyStreamFamily._()
    : super(
        retry: null,
        name: r'agencyStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches a single agency doc in real time.

  AgencyStreamProvider call(String agencyId) =>
      AgencyStreamProvider._(argument: agencyId, from: this);

  @override
  String toString() => r'agencyStreamProvider';
}

/// One-time fetch of an agency.

@ProviderFor(agencyFuture)
final agencyFutureProvider = AgencyFutureFamily._();

/// One-time fetch of an agency.

final class AgencyFutureProvider
    extends $FunctionalProvider<AsyncValue<Agency>, Agency, FutureOr<Agency>>
    with $FutureModifier<Agency>, $FutureProvider<Agency> {
  /// One-time fetch of an agency.
  AgencyFutureProvider._({
    required AgencyFutureFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'agencyFutureProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$agencyFutureHash();

  @override
  String toString() {
    return r'agencyFutureProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Agency> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Agency> create(Ref ref) {
    final argument = this.argument as String;
    return agencyFuture(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AgencyFutureProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$agencyFutureHash() => r'5dafbcbfcfe4540a0c014e4dfdb67551f547a38d';

/// One-time fetch of an agency.

final class AgencyFutureFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Agency>, String> {
  AgencyFutureFamily._()
    : super(
        retry: null,
        name: r'agencyFutureProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One-time fetch of an agency.

  AgencyFutureProvider call(String agencyId) =>
      AgencyFutureProvider._(argument: agencyId, from: this);

  @override
  String toString() => r'agencyFutureProvider';
}

/// Admin: pending agencies list.

@ProviderFor(pendingAgencies)
final pendingAgenciesProvider = PendingAgenciesProvider._();

/// Admin: pending agencies list.

final class PendingAgenciesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Agency>>,
          List<Agency>,
          FutureOr<List<Agency>>
        >
    with $FutureModifier<List<Agency>>, $FutureProvider<List<Agency>> {
  /// Admin: pending agencies list.
  PendingAgenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingAgenciesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingAgenciesHash();

  @$internal
  @override
  $FutureProviderElement<List<Agency>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Agency>> create(Ref ref) {
    return pendingAgencies(ref);
  }
}

String _$pendingAgenciesHash() => r'201d4f97296aec737cc883a4c46b3b5f1b9a5d4a';
