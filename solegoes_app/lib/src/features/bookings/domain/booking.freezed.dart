// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SelectedTripPoint {

 String get name; String get address; DateTime get dateTime;
/// Create a copy of SelectedTripPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedTripPointCopyWith<SelectedTripPoint> get copyWith => _$SelectedTripPointCopyWithImpl<SelectedTripPoint>(this as SelectedTripPoint, _$identity);

  /// Serializes this SelectedTripPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedTripPoint&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,dateTime);

@override
String toString() {
  return 'SelectedTripPoint(name: $name, address: $address, dateTime: $dateTime)';
}


}

/// @nodoc
abstract mixin class $SelectedTripPointCopyWith<$Res>  {
  factory $SelectedTripPointCopyWith(SelectedTripPoint value, $Res Function(SelectedTripPoint) _then) = _$SelectedTripPointCopyWithImpl;
@useResult
$Res call({
 String name, String address, DateTime dateTime
});




}
/// @nodoc
class _$SelectedTripPointCopyWithImpl<$Res>
    implements $SelectedTripPointCopyWith<$Res> {
  _$SelectedTripPointCopyWithImpl(this._self, this._then);

  final SelectedTripPoint _self;
  final $Res Function(SelectedTripPoint) _then;

/// Create a copy of SelectedTripPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = null,Object? dateTime = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectedTripPoint].
extension SelectedTripPointPatterns on SelectedTripPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectedTripPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedTripPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectedTripPoint value)  $default,){
final _that = this;
switch (_that) {
case _SelectedTripPoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectedTripPoint value)?  $default,){
final _that = this;
switch (_that) {
case _SelectedTripPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String address,  DateTime dateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedTripPoint() when $default != null:
return $default(_that.name,_that.address,_that.dateTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String address,  DateTime dateTime)  $default,) {final _that = this;
switch (_that) {
case _SelectedTripPoint():
return $default(_that.name,_that.address,_that.dateTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String address,  DateTime dateTime)?  $default,) {final _that = this;
switch (_that) {
case _SelectedTripPoint() when $default != null:
return $default(_that.name,_that.address,_that.dateTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SelectedTripPoint implements SelectedTripPoint {
  const _SelectedTripPoint({required this.name, required this.address, required this.dateTime});
  factory _SelectedTripPoint.fromJson(Map<String, dynamic> json) => _$SelectedTripPointFromJson(json);

@override final  String name;
@override final  String address;
@override final  DateTime dateTime;

/// Create a copy of SelectedTripPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedTripPointCopyWith<_SelectedTripPoint> get copyWith => __$SelectedTripPointCopyWithImpl<_SelectedTripPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SelectedTripPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedTripPoint&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,dateTime);

@override
String toString() {
  return 'SelectedTripPoint(name: $name, address: $address, dateTime: $dateTime)';
}


}

/// @nodoc
abstract mixin class _$SelectedTripPointCopyWith<$Res> implements $SelectedTripPointCopyWith<$Res> {
  factory _$SelectedTripPointCopyWith(_SelectedTripPoint value, $Res Function(_SelectedTripPoint) _then) = __$SelectedTripPointCopyWithImpl;
@override @useResult
$Res call({
 String name, String address, DateTime dateTime
});




}
/// @nodoc
class __$SelectedTripPointCopyWithImpl<$Res>
    implements _$SelectedTripPointCopyWith<$Res> {
  __$SelectedTripPointCopyWithImpl(this._self, this._then);

  final _SelectedTripPoint _self;
  final $Res Function(_SelectedTripPoint) _then;

/// Create a copy of SelectedTripPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = null,Object? dateTime = null,}) {
  return _then(_SelectedTripPoint(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Booking {

 String get bookingId; String get tripId; String get userId; String get tripTitle; String get tripImageUrl; String get tripLocation; int get tripDuration; double get amount; String get paymentId; String get paymentMethod; BookingStatus get status; PaymentStatus get paymentStatus; String? get failureReason; DateTime get bookingDate; DateTime? get tripStartDate; String? get userEmail; String? get userName;// Boarding and dropping point details
 SelectedTripPoint? get selectedBoardingPoint; SelectedTripPoint? get selectedDroppingPoint;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.tripTitle, tripTitle) || other.tripTitle == tripTitle)&&(identical(other.tripImageUrl, tripImageUrl) || other.tripImageUrl == tripImageUrl)&&(identical(other.tripLocation, tripLocation) || other.tripLocation == tripLocation)&&(identical(other.tripDuration, tripDuration) || other.tripDuration == tripDuration)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.tripStartDate, tripStartDate) || other.tripStartDate == tripStartDate)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.selectedBoardingPoint, selectedBoardingPoint) || other.selectedBoardingPoint == selectedBoardingPoint)&&(identical(other.selectedDroppingPoint, selectedDroppingPoint) || other.selectedDroppingPoint == selectedDroppingPoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,bookingId,tripId,userId,tripTitle,tripImageUrl,tripLocation,tripDuration,amount,paymentId,paymentMethod,status,paymentStatus,failureReason,bookingDate,tripStartDate,userEmail,userName,selectedBoardingPoint,selectedDroppingPoint]);

@override
String toString() {
  return 'Booking(bookingId: $bookingId, tripId: $tripId, userId: $userId, tripTitle: $tripTitle, tripImageUrl: $tripImageUrl, tripLocation: $tripLocation, tripDuration: $tripDuration, amount: $amount, paymentId: $paymentId, paymentMethod: $paymentMethod, status: $status, paymentStatus: $paymentStatus, failureReason: $failureReason, bookingDate: $bookingDate, tripStartDate: $tripStartDate, userEmail: $userEmail, userName: $userName, selectedBoardingPoint: $selectedBoardingPoint, selectedDroppingPoint: $selectedDroppingPoint)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String bookingId, String tripId, String userId, String tripTitle, String tripImageUrl, String tripLocation, int tripDuration, double amount, String paymentId, String paymentMethod, BookingStatus status, PaymentStatus paymentStatus, String? failureReason, DateTime bookingDate, DateTime? tripStartDate, String? userEmail, String? userName, SelectedTripPoint? selectedBoardingPoint, SelectedTripPoint? selectedDroppingPoint
});


$SelectedTripPointCopyWith<$Res>? get selectedBoardingPoint;$SelectedTripPointCopyWith<$Res>? get selectedDroppingPoint;

}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingId = null,Object? tripId = null,Object? userId = null,Object? tripTitle = null,Object? tripImageUrl = null,Object? tripLocation = null,Object? tripDuration = null,Object? amount = null,Object? paymentId = null,Object? paymentMethod = null,Object? status = null,Object? paymentStatus = null,Object? failureReason = freezed,Object? bookingDate = null,Object? tripStartDate = freezed,Object? userEmail = freezed,Object? userName = freezed,Object? selectedBoardingPoint = freezed,Object? selectedDroppingPoint = freezed,}) {
  return _then(_self.copyWith(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,tripTitle: null == tripTitle ? _self.tripTitle : tripTitle // ignore: cast_nullable_to_non_nullable
as String,tripImageUrl: null == tripImageUrl ? _self.tripImageUrl : tripImageUrl // ignore: cast_nullable_to_non_nullable
as String,tripLocation: null == tripLocation ? _self.tripLocation : tripLocation // ignore: cast_nullable_to_non_nullable
as String,tripDuration: null == tripDuration ? _self.tripDuration : tripDuration // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,bookingDate: null == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as DateTime,tripStartDate: freezed == tripStartDate ? _self.tripStartDate : tripStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,selectedBoardingPoint: freezed == selectedBoardingPoint ? _self.selectedBoardingPoint : selectedBoardingPoint // ignore: cast_nullable_to_non_nullable
as SelectedTripPoint?,selectedDroppingPoint: freezed == selectedDroppingPoint ? _self.selectedDroppingPoint : selectedDroppingPoint // ignore: cast_nullable_to_non_nullable
as SelectedTripPoint?,
  ));
}
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SelectedTripPointCopyWith<$Res>? get selectedBoardingPoint {
    if (_self.selectedBoardingPoint == null) {
    return null;
  }

  return $SelectedTripPointCopyWith<$Res>(_self.selectedBoardingPoint!, (value) {
    return _then(_self.copyWith(selectedBoardingPoint: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SelectedTripPointCopyWith<$Res>? get selectedDroppingPoint {
    if (_self.selectedDroppingPoint == null) {
    return null;
  }

  return $SelectedTripPointCopyWith<$Res>(_self.selectedDroppingPoint!, (value) {
    return _then(_self.copyWith(selectedDroppingPoint: value));
  });
}
}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bookingId,  String tripId,  String userId,  String tripTitle,  String tripImageUrl,  String tripLocation,  int tripDuration,  double amount,  String paymentId,  String paymentMethod,  BookingStatus status,  PaymentStatus paymentStatus,  String? failureReason,  DateTime bookingDate,  DateTime? tripStartDate,  String? userEmail,  String? userName,  SelectedTripPoint? selectedBoardingPoint,  SelectedTripPoint? selectedDroppingPoint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.bookingId,_that.tripId,_that.userId,_that.tripTitle,_that.tripImageUrl,_that.tripLocation,_that.tripDuration,_that.amount,_that.paymentId,_that.paymentMethod,_that.status,_that.paymentStatus,_that.failureReason,_that.bookingDate,_that.tripStartDate,_that.userEmail,_that.userName,_that.selectedBoardingPoint,_that.selectedDroppingPoint);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bookingId,  String tripId,  String userId,  String tripTitle,  String tripImageUrl,  String tripLocation,  int tripDuration,  double amount,  String paymentId,  String paymentMethod,  BookingStatus status,  PaymentStatus paymentStatus,  String? failureReason,  DateTime bookingDate,  DateTime? tripStartDate,  String? userEmail,  String? userName,  SelectedTripPoint? selectedBoardingPoint,  SelectedTripPoint? selectedDroppingPoint)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.bookingId,_that.tripId,_that.userId,_that.tripTitle,_that.tripImageUrl,_that.tripLocation,_that.tripDuration,_that.amount,_that.paymentId,_that.paymentMethod,_that.status,_that.paymentStatus,_that.failureReason,_that.bookingDate,_that.tripStartDate,_that.userEmail,_that.userName,_that.selectedBoardingPoint,_that.selectedDroppingPoint);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bookingId,  String tripId,  String userId,  String tripTitle,  String tripImageUrl,  String tripLocation,  int tripDuration,  double amount,  String paymentId,  String paymentMethod,  BookingStatus status,  PaymentStatus paymentStatus,  String? failureReason,  DateTime bookingDate,  DateTime? tripStartDate,  String? userEmail,  String? userName,  SelectedTripPoint? selectedBoardingPoint,  SelectedTripPoint? selectedDroppingPoint)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.bookingId,_that.tripId,_that.userId,_that.tripTitle,_that.tripImageUrl,_that.tripLocation,_that.tripDuration,_that.amount,_that.paymentId,_that.paymentMethod,_that.status,_that.paymentStatus,_that.failureReason,_that.bookingDate,_that.tripStartDate,_that.userEmail,_that.userName,_that.selectedBoardingPoint,_that.selectedDroppingPoint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Booking implements Booking {
  const _Booking({required this.bookingId, required this.tripId, required this.userId, required this.tripTitle, required this.tripImageUrl, required this.tripLocation, required this.tripDuration, required this.amount, required this.paymentId, required this.paymentMethod, this.status = BookingStatus.confirmed, this.paymentStatus = PaymentStatus.success, this.failureReason, required this.bookingDate, this.tripStartDate, this.userEmail, this.userName, this.selectedBoardingPoint, this.selectedDroppingPoint});
  factory _Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

@override final  String bookingId;
@override final  String tripId;
@override final  String userId;
@override final  String tripTitle;
@override final  String tripImageUrl;
@override final  String tripLocation;
@override final  int tripDuration;
@override final  double amount;
@override final  String paymentId;
@override final  String paymentMethod;
@override@JsonKey() final  BookingStatus status;
@override@JsonKey() final  PaymentStatus paymentStatus;
@override final  String? failureReason;
@override final  DateTime bookingDate;
@override final  DateTime? tripStartDate;
@override final  String? userEmail;
@override final  String? userName;
// Boarding and dropping point details
@override final  SelectedTripPoint? selectedBoardingPoint;
@override final  SelectedTripPoint? selectedDroppingPoint;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.tripTitle, tripTitle) || other.tripTitle == tripTitle)&&(identical(other.tripImageUrl, tripImageUrl) || other.tripImageUrl == tripImageUrl)&&(identical(other.tripLocation, tripLocation) || other.tripLocation == tripLocation)&&(identical(other.tripDuration, tripDuration) || other.tripDuration == tripDuration)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.tripStartDate, tripStartDate) || other.tripStartDate == tripStartDate)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.selectedBoardingPoint, selectedBoardingPoint) || other.selectedBoardingPoint == selectedBoardingPoint)&&(identical(other.selectedDroppingPoint, selectedDroppingPoint) || other.selectedDroppingPoint == selectedDroppingPoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,bookingId,tripId,userId,tripTitle,tripImageUrl,tripLocation,tripDuration,amount,paymentId,paymentMethod,status,paymentStatus,failureReason,bookingDate,tripStartDate,userEmail,userName,selectedBoardingPoint,selectedDroppingPoint]);

@override
String toString() {
  return 'Booking(bookingId: $bookingId, tripId: $tripId, userId: $userId, tripTitle: $tripTitle, tripImageUrl: $tripImageUrl, tripLocation: $tripLocation, tripDuration: $tripDuration, amount: $amount, paymentId: $paymentId, paymentMethod: $paymentMethod, status: $status, paymentStatus: $paymentStatus, failureReason: $failureReason, bookingDate: $bookingDate, tripStartDate: $tripStartDate, userEmail: $userEmail, userName: $userName, selectedBoardingPoint: $selectedBoardingPoint, selectedDroppingPoint: $selectedDroppingPoint)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String bookingId, String tripId, String userId, String tripTitle, String tripImageUrl, String tripLocation, int tripDuration, double amount, String paymentId, String paymentMethod, BookingStatus status, PaymentStatus paymentStatus, String? failureReason, DateTime bookingDate, DateTime? tripStartDate, String? userEmail, String? userName, SelectedTripPoint? selectedBoardingPoint, SelectedTripPoint? selectedDroppingPoint
});


@override $SelectedTripPointCopyWith<$Res>? get selectedBoardingPoint;@override $SelectedTripPointCopyWith<$Res>? get selectedDroppingPoint;

}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingId = null,Object? tripId = null,Object? userId = null,Object? tripTitle = null,Object? tripImageUrl = null,Object? tripLocation = null,Object? tripDuration = null,Object? amount = null,Object? paymentId = null,Object? paymentMethod = null,Object? status = null,Object? paymentStatus = null,Object? failureReason = freezed,Object? bookingDate = null,Object? tripStartDate = freezed,Object? userEmail = freezed,Object? userName = freezed,Object? selectedBoardingPoint = freezed,Object? selectedDroppingPoint = freezed,}) {
  return _then(_Booking(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,tripTitle: null == tripTitle ? _self.tripTitle : tripTitle // ignore: cast_nullable_to_non_nullable
as String,tripImageUrl: null == tripImageUrl ? _self.tripImageUrl : tripImageUrl // ignore: cast_nullable_to_non_nullable
as String,tripLocation: null == tripLocation ? _self.tripLocation : tripLocation // ignore: cast_nullable_to_non_nullable
as String,tripDuration: null == tripDuration ? _self.tripDuration : tripDuration // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,bookingDate: null == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as DateTime,tripStartDate: freezed == tripStartDate ? _self.tripStartDate : tripStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,selectedBoardingPoint: freezed == selectedBoardingPoint ? _self.selectedBoardingPoint : selectedBoardingPoint // ignore: cast_nullable_to_non_nullable
as SelectedTripPoint?,selectedDroppingPoint: freezed == selectedDroppingPoint ? _self.selectedDroppingPoint : selectedDroppingPoint // ignore: cast_nullable_to_non_nullable
as SelectedTripPoint?,
  ));
}

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SelectedTripPointCopyWith<$Res>? get selectedBoardingPoint {
    if (_self.selectedBoardingPoint == null) {
    return null;
  }

  return $SelectedTripPointCopyWith<$Res>(_self.selectedBoardingPoint!, (value) {
    return _then(_self.copyWith(selectedBoardingPoint: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SelectedTripPointCopyWith<$Res>? get selectedDroppingPoint {
    if (_self.selectedDroppingPoint == null) {
    return null;
  }

  return $SelectedTripPointCopyWith<$Res>(_self.selectedDroppingPoint!, (value) {
    return _then(_self.copyWith(selectedDroppingPoint: value));
  });
}
}

// dart format on
