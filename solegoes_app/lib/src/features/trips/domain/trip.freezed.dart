// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Trip {

 String get tripId; String get title; String get description; String get imageUrl; List<String> get imageUrls; String get location; int get duration;// in days
 double get price; List<String> get categories; String get groupSize; double get rating; int get reviewCount; String get agencyId; String get agencyName; bool get isVerifiedAgency; String get status;// 'pending_approval', 'live', 'rejected', 'completed'
 List<String> get inclusions; List<Map<String, dynamic>> get itinerary;// Simplified: store as maps
 bool get isTrending; bool get isFeatured; DateTime? get startDate; DateTime? get endDate;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripCopyWith<Trip> get copyWith => _$TripCopyWithImpl<Trip>(this as Trip, _$identity);

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Trip&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.location, location) || other.location == location)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.groupSize, groupSize) || other.groupSize == groupSize)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.agencyId, agencyId) || other.agencyId == agencyId)&&(identical(other.agencyName, agencyName) || other.agencyName == agencyName)&&(identical(other.isVerifiedAgency, isVerifiedAgency) || other.isVerifiedAgency == isVerifiedAgency)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.inclusions, inclusions)&&const DeepCollectionEquality().equals(other.itinerary, itinerary)&&(identical(other.isTrending, isTrending) || other.isTrending == isTrending)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,tripId,title,description,imageUrl,const DeepCollectionEquality().hash(imageUrls),location,duration,price,const DeepCollectionEquality().hash(categories),groupSize,rating,reviewCount,agencyId,agencyName,isVerifiedAgency,status,const DeepCollectionEquality().hash(inclusions),const DeepCollectionEquality().hash(itinerary),isTrending,isFeatured,startDate,endDate,createdAt,updatedAt]);

@override
String toString() {
  return 'Trip(tripId: $tripId, title: $title, description: $description, imageUrl: $imageUrl, imageUrls: $imageUrls, location: $location, duration: $duration, price: $price, categories: $categories, groupSize: $groupSize, rating: $rating, reviewCount: $reviewCount, agencyId: $agencyId, agencyName: $agencyName, isVerifiedAgency: $isVerifiedAgency, status: $status, inclusions: $inclusions, itinerary: $itinerary, isTrending: $isTrending, isFeatured: $isFeatured, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TripCopyWith<$Res>  {
  factory $TripCopyWith(Trip value, $Res Function(Trip) _then) = _$TripCopyWithImpl;
@useResult
$Res call({
 String tripId, String title, String description, String imageUrl, List<String> imageUrls, String location, int duration, double price, List<String> categories, String groupSize, double rating, int reviewCount, String agencyId, String agencyName, bool isVerifiedAgency, String status, List<String> inclusions, List<Map<String, dynamic>> itinerary, bool isTrending, bool isFeatured, DateTime? startDate, DateTime? endDate,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$TripCopyWithImpl<$Res>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._self, this._then);

  final Trip _self;
  final $Res Function(Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tripId = null,Object? title = null,Object? description = null,Object? imageUrl = null,Object? imageUrls = null,Object? location = null,Object? duration = null,Object? price = null,Object? categories = null,Object? groupSize = null,Object? rating = null,Object? reviewCount = null,Object? agencyId = null,Object? agencyName = null,Object? isVerifiedAgency = null,Object? status = null,Object? inclusions = null,Object? itinerary = null,Object? isTrending = null,Object? isFeatured = null,Object? startDate = freezed,Object? endDate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,groupSize: null == groupSize ? _self.groupSize : groupSize // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,agencyId: null == agencyId ? _self.agencyId : agencyId // ignore: cast_nullable_to_non_nullable
as String,agencyName: null == agencyName ? _self.agencyName : agencyName // ignore: cast_nullable_to_non_nullable
as String,isVerifiedAgency: null == isVerifiedAgency ? _self.isVerifiedAgency : isVerifiedAgency // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,inclusions: null == inclusions ? _self.inclusions : inclusions // ignore: cast_nullable_to_non_nullable
as List<String>,itinerary: null == itinerary ? _self.itinerary : itinerary // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isTrending: null == isTrending ? _self.isTrending : isTrending // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Trip].
extension TripPatterns on Trip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Trip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Trip value)  $default,){
final _that = this;
switch (_that) {
case _Trip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Trip value)?  $default,){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tripId,  String title,  String description,  String imageUrl,  List<String> imageUrls,  String location,  int duration,  double price,  List<String> categories,  String groupSize,  double rating,  int reviewCount,  String agencyId,  String agencyName,  bool isVerifiedAgency,  String status,  List<String> inclusions,  List<Map<String, dynamic>> itinerary,  bool isTrending,  bool isFeatured,  DateTime? startDate,  DateTime? endDate, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.tripId,_that.title,_that.description,_that.imageUrl,_that.imageUrls,_that.location,_that.duration,_that.price,_that.categories,_that.groupSize,_that.rating,_that.reviewCount,_that.agencyId,_that.agencyName,_that.isVerifiedAgency,_that.status,_that.inclusions,_that.itinerary,_that.isTrending,_that.isFeatured,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tripId,  String title,  String description,  String imageUrl,  List<String> imageUrls,  String location,  int duration,  double price,  List<String> categories,  String groupSize,  double rating,  int reviewCount,  String agencyId,  String agencyName,  bool isVerifiedAgency,  String status,  List<String> inclusions,  List<Map<String, dynamic>> itinerary,  bool isTrending,  bool isFeatured,  DateTime? startDate,  DateTime? endDate, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Trip():
return $default(_that.tripId,_that.title,_that.description,_that.imageUrl,_that.imageUrls,_that.location,_that.duration,_that.price,_that.categories,_that.groupSize,_that.rating,_that.reviewCount,_that.agencyId,_that.agencyName,_that.isVerifiedAgency,_that.status,_that.inclusions,_that.itinerary,_that.isTrending,_that.isFeatured,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tripId,  String title,  String description,  String imageUrl,  List<String> imageUrls,  String location,  int duration,  double price,  List<String> categories,  String groupSize,  double rating,  int reviewCount,  String agencyId,  String agencyName,  bool isVerifiedAgency,  String status,  List<String> inclusions,  List<Map<String, dynamic>> itinerary,  bool isTrending,  bool isFeatured,  DateTime? startDate,  DateTime? endDate, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.tripId,_that.title,_that.description,_that.imageUrl,_that.imageUrls,_that.location,_that.duration,_that.price,_that.categories,_that.groupSize,_that.rating,_that.reviewCount,_that.agencyId,_that.agencyName,_that.isVerifiedAgency,_that.status,_that.inclusions,_that.itinerary,_that.isTrending,_that.isFeatured,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Trip extends Trip {
  const _Trip({required this.tripId, required this.title, required this.description, required this.imageUrl, required final  List<String> imageUrls, required this.location, required this.duration, required this.price, required final  List<String> categories, required this.groupSize, required this.rating, required this.reviewCount, required this.agencyId, required this.agencyName, required this.isVerifiedAgency, required this.status, required final  List<String> inclusions, required final  List<Map<String, dynamic>> itinerary, this.isTrending = false, this.isFeatured = false, this.startDate, this.endDate, @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt}): _imageUrls = imageUrls,_categories = categories,_inclusions = inclusions,_itinerary = itinerary,super._();
  factory _Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

@override final  String tripId;
@override final  String title;
@override final  String description;
@override final  String imageUrl;
 final  List<String> _imageUrls;
@override List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  String location;
@override final  int duration;
// in days
@override final  double price;
 final  List<String> _categories;
@override List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override final  String groupSize;
@override final  double rating;
@override final  int reviewCount;
@override final  String agencyId;
@override final  String agencyName;
@override final  bool isVerifiedAgency;
@override final  String status;
// 'pending_approval', 'live', 'rejected', 'completed'
 final  List<String> _inclusions;
// 'pending_approval', 'live', 'rejected', 'completed'
@override List<String> get inclusions {
  if (_inclusions is EqualUnmodifiableListView) return _inclusions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inclusions);
}

 final  List<Map<String, dynamic>> _itinerary;
@override List<Map<String, dynamic>> get itinerary {
  if (_itinerary is EqualUnmodifiableListView) return _itinerary;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itinerary);
}

// Simplified: store as maps
@override@JsonKey() final  bool isTrending;
@override@JsonKey() final  bool isFeatured;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripCopyWith<_Trip> get copyWith => __$TripCopyWithImpl<_Trip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Trip&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.location, location) || other.location == location)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.groupSize, groupSize) || other.groupSize == groupSize)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.agencyId, agencyId) || other.agencyId == agencyId)&&(identical(other.agencyName, agencyName) || other.agencyName == agencyName)&&(identical(other.isVerifiedAgency, isVerifiedAgency) || other.isVerifiedAgency == isVerifiedAgency)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._inclusions, _inclusions)&&const DeepCollectionEquality().equals(other._itinerary, _itinerary)&&(identical(other.isTrending, isTrending) || other.isTrending == isTrending)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,tripId,title,description,imageUrl,const DeepCollectionEquality().hash(_imageUrls),location,duration,price,const DeepCollectionEquality().hash(_categories),groupSize,rating,reviewCount,agencyId,agencyName,isVerifiedAgency,status,const DeepCollectionEquality().hash(_inclusions),const DeepCollectionEquality().hash(_itinerary),isTrending,isFeatured,startDate,endDate,createdAt,updatedAt]);

@override
String toString() {
  return 'Trip(tripId: $tripId, title: $title, description: $description, imageUrl: $imageUrl, imageUrls: $imageUrls, location: $location, duration: $duration, price: $price, categories: $categories, groupSize: $groupSize, rating: $rating, reviewCount: $reviewCount, agencyId: $agencyId, agencyName: $agencyName, isVerifiedAgency: $isVerifiedAgency, status: $status, inclusions: $inclusions, itinerary: $itinerary, isTrending: $isTrending, isFeatured: $isFeatured, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TripCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$TripCopyWith(_Trip value, $Res Function(_Trip) _then) = __$TripCopyWithImpl;
@override @useResult
$Res call({
 String tripId, String title, String description, String imageUrl, List<String> imageUrls, String location, int duration, double price, List<String> categories, String groupSize, double rating, int reviewCount, String agencyId, String agencyName, bool isVerifiedAgency, String status, List<String> inclusions, List<Map<String, dynamic>> itinerary, bool isTrending, bool isFeatured, DateTime? startDate, DateTime? endDate,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$TripCopyWithImpl<$Res>
    implements _$TripCopyWith<$Res> {
  __$TripCopyWithImpl(this._self, this._then);

  final _Trip _self;
  final $Res Function(_Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tripId = null,Object? title = null,Object? description = null,Object? imageUrl = null,Object? imageUrls = null,Object? location = null,Object? duration = null,Object? price = null,Object? categories = null,Object? groupSize = null,Object? rating = null,Object? reviewCount = null,Object? agencyId = null,Object? agencyName = null,Object? isVerifiedAgency = null,Object? status = null,Object? inclusions = null,Object? itinerary = null,Object? isTrending = null,Object? isFeatured = null,Object? startDate = freezed,Object? endDate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Trip(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,groupSize: null == groupSize ? _self.groupSize : groupSize // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,agencyId: null == agencyId ? _self.agencyId : agencyId // ignore: cast_nullable_to_non_nullable
as String,agencyName: null == agencyName ? _self.agencyName : agencyName // ignore: cast_nullable_to_non_nullable
as String,isVerifiedAgency: null == isVerifiedAgency ? _self.isVerifiedAgency : isVerifiedAgency // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,inclusions: null == inclusions ? _self._inclusions : inclusions // ignore: cast_nullable_to_non_nullable
as List<String>,itinerary: null == itinerary ? _self._itinerary : itinerary // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,isTrending: null == isTrending ? _self.isTrending : isTrending // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
