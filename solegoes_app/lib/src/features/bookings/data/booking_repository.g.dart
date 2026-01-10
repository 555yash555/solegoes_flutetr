// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for BookingRepository

@ProviderFor(bookingRepository)
final bookingRepositoryProvider = BookingRepositoryProvider._();

/// Provider for BookingRepository

final class BookingRepositoryProvider
    extends
        $FunctionalProvider<
          BookingRepository,
          BookingRepository,
          BookingRepository
        >
    with $Provider<BookingRepository> {
  /// Provider for BookingRepository
  BookingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingRepository create(Ref ref) {
    return bookingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingRepository>(value),
    );
  }
}

String _$bookingRepositoryHash() => r'b3fdd6f71291f1bd8a3a073d9ba26cf1c620bad1';

/// Provider for user's bookings stream

@ProviderFor(userBookings)
final userBookingsProvider = UserBookingsFamily._();

/// Provider for user's bookings stream

final class UserBookingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Booking>>,
          List<Booking>,
          Stream<List<Booking>>
        >
    with $FutureModifier<List<Booking>>, $StreamProvider<List<Booking>> {
  /// Provider for user's bookings stream
  UserBookingsProvider._({
    required UserBookingsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userBookingsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userBookingsHash();

  @override
  String toString() {
    return r'userBookingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Booking>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Booking>> create(Ref ref) {
    final argument = this.argument as String;
    return userBookings(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserBookingsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userBookingsHash() => r'a517e1cabb8f9ea480826d248ce0a6dabca24ce1';

/// Provider for user's bookings stream

final class UserBookingsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Booking>>, String> {
  UserBookingsFamily._()
    : super(
        retry: null,
        name: r'userBookingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for user's bookings stream

  UserBookingsProvider call(String userId) =>
      UserBookingsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userBookingsProvider';
}

/// Provider for a single booking

@ProviderFor(booking)
final bookingProvider = BookingFamily._();

/// Provider for a single booking

final class BookingProvider
    extends
        $FunctionalProvider<AsyncValue<Booking?>, Booking?, FutureOr<Booking?>>
    with $FutureModifier<Booking?>, $FutureProvider<Booking?> {
  /// Provider for a single booking
  BookingProvider._({
    required BookingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingHash();

  @override
  String toString() {
    return r'bookingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Booking?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Booking?> create(Ref ref) {
    final argument = this.argument as String;
    return booking(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingHash() => r'6f59b20b7d403b8dff6d0ff9290dc7b7c635dd64';

/// Provider for a single booking

final class BookingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Booking?>, String> {
  BookingFamily._()
    : super(
        retry: null,
        name: r'bookingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single booking

  BookingProvider call(String bookingId) =>
      BookingProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'bookingProvider';
}

/// Provider for booking by payment ID

@ProviderFor(bookingByPaymentId)
final bookingByPaymentIdProvider = BookingByPaymentIdFamily._();

/// Provider for booking by payment ID

final class BookingByPaymentIdProvider
    extends
        $FunctionalProvider<AsyncValue<Booking?>, Booking?, FutureOr<Booking?>>
    with $FutureModifier<Booking?>, $FutureProvider<Booking?> {
  /// Provider for booking by payment ID
  BookingByPaymentIdProvider._({
    required BookingByPaymentIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookingByPaymentIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingByPaymentIdHash();

  @override
  String toString() {
    return r'bookingByPaymentIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Booking?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Booking?> create(Ref ref) {
    final argument = this.argument as String;
    return bookingByPaymentId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingByPaymentIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingByPaymentIdHash() =>
    r'591a6c6a7aa9333a753ae0ec2b3d2ec4b23dc358';

/// Provider for booking by payment ID

final class BookingByPaymentIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Booking?>, String> {
  BookingByPaymentIdFamily._()
    : super(
        retry: null,
        name: r'bookingByPaymentIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for booking by payment ID

  BookingByPaymentIdProvider call(String paymentId) =>
      BookingByPaymentIdProvider._(argument: paymentId, from: this);

  @override
  String toString() => r'bookingByPaymentIdProvider';
}

/// Provider to check if user has booked a specific trip

@ProviderFor(userTripBooking)
final userTripBookingProvider = UserTripBookingFamily._();

/// Provider to check if user has booked a specific trip

final class UserTripBookingProvider
    extends
        $FunctionalProvider<AsyncValue<Booking?>, Booking?, FutureOr<Booking?>>
    with $FutureModifier<Booking?>, $FutureProvider<Booking?> {
  /// Provider to check if user has booked a specific trip
  UserTripBookingProvider._({
    required UserTripBookingFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'userTripBookingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userTripBookingHash();

  @override
  String toString() {
    return r'userTripBookingProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Booking?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Booking?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return userTripBooking(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is UserTripBookingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userTripBookingHash() => r'fabaa688297d6953df55beba990aa95b38728334';

/// Provider to check if user has booked a specific trip

final class UserTripBookingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Booking?>, (String, String)> {
  UserTripBookingFamily._()
    : super(
        retry: null,
        name: r'userTripBookingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider to check if user has booked a specific trip

  UserTripBookingProvider call(String tripId, String userId) =>
      UserTripBookingProvider._(argument: (tripId, userId), from: this);

  @override
  String toString() => r'userTripBookingProvider';
}
