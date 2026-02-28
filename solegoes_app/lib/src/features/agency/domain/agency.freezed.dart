// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Agency {

 String get agencyId; String get ownerUid; String get businessName; String get email; String get phone; String get description; String get logoUrl; String get coverImageUrl;/// verificationStatus: 'pending' | 'approved' | 'rejected'
 String get verificationStatus; String get gstin; String get teamSize; int get yearsExperience; bool get isVerified; double get rating; int get totalTrips; int get totalBookings; List<String> get specialties;/// Denormalized stats: { totalRevenue, activeBookings, completedTrips }
 Map<String, dynamic> get stats;/// Document URLs: { gstCertificate, portfolioPhotos }
 Map<String, dynamic> get documents;// Bank details (stored encrypted in production)
 String get bankAccountHolder; String get bankName; String get bankIfsc; String get bankAccountNumberMasked; DateTime? get createdAt;
/// Create a copy of Agency
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgencyCopyWith<Agency> get copyWith => _$AgencyCopyWithImpl<Agency>(this as Agency, _$identity);

  /// Serializes this Agency to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Agency&&(identical(other.agencyId, agencyId) || other.agencyId == agencyId)&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&(identical(other.teamSize, teamSize) || other.teamSize == teamSize)&&(identical(other.yearsExperience, yearsExperience) || other.yearsExperience == yearsExperience)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalTrips, totalTrips) || other.totalTrips == totalTrips)&&(identical(other.totalBookings, totalBookings) || other.totalBookings == totalBookings)&&const DeepCollectionEquality().equals(other.specialties, specialties)&&const DeepCollectionEquality().equals(other.stats, stats)&&const DeepCollectionEquality().equals(other.documents, documents)&&(identical(other.bankAccountHolder, bankAccountHolder) || other.bankAccountHolder == bankAccountHolder)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.bankIfsc, bankIfsc) || other.bankIfsc == bankIfsc)&&(identical(other.bankAccountNumberMasked, bankAccountNumberMasked) || other.bankAccountNumberMasked == bankAccountNumberMasked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,agencyId,ownerUid,businessName,email,phone,description,logoUrl,coverImageUrl,verificationStatus,gstin,teamSize,yearsExperience,isVerified,rating,totalTrips,totalBookings,const DeepCollectionEquality().hash(specialties),const DeepCollectionEquality().hash(stats),const DeepCollectionEquality().hash(documents),bankAccountHolder,bankName,bankIfsc,bankAccountNumberMasked,createdAt]);

@override
String toString() {
  return 'Agency(agencyId: $agencyId, ownerUid: $ownerUid, businessName: $businessName, email: $email, phone: $phone, description: $description, logoUrl: $logoUrl, coverImageUrl: $coverImageUrl, verificationStatus: $verificationStatus, gstin: $gstin, teamSize: $teamSize, yearsExperience: $yearsExperience, isVerified: $isVerified, rating: $rating, totalTrips: $totalTrips, totalBookings: $totalBookings, specialties: $specialties, stats: $stats, documents: $documents, bankAccountHolder: $bankAccountHolder, bankName: $bankName, bankIfsc: $bankIfsc, bankAccountNumberMasked: $bankAccountNumberMasked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AgencyCopyWith<$Res>  {
  factory $AgencyCopyWith(Agency value, $Res Function(Agency) _then) = _$AgencyCopyWithImpl;
@useResult
$Res call({
 String agencyId, String ownerUid, String businessName, String email, String phone, String description, String logoUrl, String coverImageUrl, String verificationStatus, String gstin, String teamSize, int yearsExperience, bool isVerified, double rating, int totalTrips, int totalBookings, List<String> specialties, Map<String, dynamic> stats, Map<String, dynamic> documents, String bankAccountHolder, String bankName, String bankIfsc, String bankAccountNumberMasked, DateTime? createdAt
});




}
/// @nodoc
class _$AgencyCopyWithImpl<$Res>
    implements $AgencyCopyWith<$Res> {
  _$AgencyCopyWithImpl(this._self, this._then);

  final Agency _self;
  final $Res Function(Agency) _then;

/// Create a copy of Agency
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agencyId = null,Object? ownerUid = null,Object? businessName = null,Object? email = null,Object? phone = null,Object? description = null,Object? logoUrl = null,Object? coverImageUrl = null,Object? verificationStatus = null,Object? gstin = null,Object? teamSize = null,Object? yearsExperience = null,Object? isVerified = null,Object? rating = null,Object? totalTrips = null,Object? totalBookings = null,Object? specialties = null,Object? stats = null,Object? documents = null,Object? bankAccountHolder = null,Object? bankName = null,Object? bankIfsc = null,Object? bankAccountNumberMasked = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
agencyId: null == agencyId ? _self.agencyId : agencyId // ignore: cast_nullable_to_non_nullable
as String,ownerUid: null == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,coverImageUrl: null == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as String,gstin: null == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String,teamSize: null == teamSize ? _self.teamSize : teamSize // ignore: cast_nullable_to_non_nullable
as String,yearsExperience: null == yearsExperience ? _self.yearsExperience : yearsExperience // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalTrips: null == totalTrips ? _self.totalTrips : totalTrips // ignore: cast_nullable_to_non_nullable
as int,totalBookings: null == totalBookings ? _self.totalBookings : totalBookings // ignore: cast_nullable_to_non_nullable
as int,specialties: null == specialties ? _self.specialties : specialties // ignore: cast_nullable_to_non_nullable
as List<String>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,bankAccountHolder: null == bankAccountHolder ? _self.bankAccountHolder : bankAccountHolder // ignore: cast_nullable_to_non_nullable
as String,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,bankIfsc: null == bankIfsc ? _self.bankIfsc : bankIfsc // ignore: cast_nullable_to_non_nullable
as String,bankAccountNumberMasked: null == bankAccountNumberMasked ? _self.bankAccountNumberMasked : bankAccountNumberMasked // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Agency].
extension AgencyPatterns on Agency {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Agency value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Agency() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Agency value)  $default,){
final _that = this;
switch (_that) {
case _Agency():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Agency value)?  $default,){
final _that = this;
switch (_that) {
case _Agency() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String agencyId,  String ownerUid,  String businessName,  String email,  String phone,  String description,  String logoUrl,  String coverImageUrl,  String verificationStatus,  String gstin,  String teamSize,  int yearsExperience,  bool isVerified,  double rating,  int totalTrips,  int totalBookings,  List<String> specialties,  Map<String, dynamic> stats,  Map<String, dynamic> documents,  String bankAccountHolder,  String bankName,  String bankIfsc,  String bankAccountNumberMasked,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Agency() when $default != null:
return $default(_that.agencyId,_that.ownerUid,_that.businessName,_that.email,_that.phone,_that.description,_that.logoUrl,_that.coverImageUrl,_that.verificationStatus,_that.gstin,_that.teamSize,_that.yearsExperience,_that.isVerified,_that.rating,_that.totalTrips,_that.totalBookings,_that.specialties,_that.stats,_that.documents,_that.bankAccountHolder,_that.bankName,_that.bankIfsc,_that.bankAccountNumberMasked,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String agencyId,  String ownerUid,  String businessName,  String email,  String phone,  String description,  String logoUrl,  String coverImageUrl,  String verificationStatus,  String gstin,  String teamSize,  int yearsExperience,  bool isVerified,  double rating,  int totalTrips,  int totalBookings,  List<String> specialties,  Map<String, dynamic> stats,  Map<String, dynamic> documents,  String bankAccountHolder,  String bankName,  String bankIfsc,  String bankAccountNumberMasked,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Agency():
return $default(_that.agencyId,_that.ownerUid,_that.businessName,_that.email,_that.phone,_that.description,_that.logoUrl,_that.coverImageUrl,_that.verificationStatus,_that.gstin,_that.teamSize,_that.yearsExperience,_that.isVerified,_that.rating,_that.totalTrips,_that.totalBookings,_that.specialties,_that.stats,_that.documents,_that.bankAccountHolder,_that.bankName,_that.bankIfsc,_that.bankAccountNumberMasked,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String agencyId,  String ownerUid,  String businessName,  String email,  String phone,  String description,  String logoUrl,  String coverImageUrl,  String verificationStatus,  String gstin,  String teamSize,  int yearsExperience,  bool isVerified,  double rating,  int totalTrips,  int totalBookings,  List<String> specialties,  Map<String, dynamic> stats,  Map<String, dynamic> documents,  String bankAccountHolder,  String bankName,  String bankIfsc,  String bankAccountNumberMasked,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Agency() when $default != null:
return $default(_that.agencyId,_that.ownerUid,_that.businessName,_that.email,_that.phone,_that.description,_that.logoUrl,_that.coverImageUrl,_that.verificationStatus,_that.gstin,_that.teamSize,_that.yearsExperience,_that.isVerified,_that.rating,_that.totalTrips,_that.totalBookings,_that.specialties,_that.stats,_that.documents,_that.bankAccountHolder,_that.bankName,_that.bankIfsc,_that.bankAccountNumberMasked,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Agency implements Agency {
  const _Agency({required this.agencyId, required this.ownerUid, required this.businessName, required this.email, required this.phone, this.description = '', this.logoUrl = '', this.coverImageUrl = '', this.verificationStatus = 'pending', this.gstin = '', this.teamSize = '', this.yearsExperience = 0, this.isVerified = false, this.rating = 0.0, this.totalTrips = 0, this.totalBookings = 0, final  List<String> specialties = const [], final  Map<String, dynamic> stats = const {}, final  Map<String, dynamic> documents = const {}, this.bankAccountHolder = '', this.bankName = '', this.bankIfsc = '', this.bankAccountNumberMasked = '', this.createdAt}): _specialties = specialties,_stats = stats,_documents = documents;
  factory _Agency.fromJson(Map<String, dynamic> json) => _$AgencyFromJson(json);

@override final  String agencyId;
@override final  String ownerUid;
@override final  String businessName;
@override final  String email;
@override final  String phone;
@override@JsonKey() final  String description;
@override@JsonKey() final  String logoUrl;
@override@JsonKey() final  String coverImageUrl;
/// verificationStatus: 'pending' | 'approved' | 'rejected'
@override@JsonKey() final  String verificationStatus;
@override@JsonKey() final  String gstin;
@override@JsonKey() final  String teamSize;
@override@JsonKey() final  int yearsExperience;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int totalTrips;
@override@JsonKey() final  int totalBookings;
 final  List<String> _specialties;
@override@JsonKey() List<String> get specialties {
  if (_specialties is EqualUnmodifiableListView) return _specialties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specialties);
}

/// Denormalized stats: { totalRevenue, activeBookings, completedTrips }
 final  Map<String, dynamic> _stats;
/// Denormalized stats: { totalRevenue, activeBookings, completedTrips }
@override@JsonKey() Map<String, dynamic> get stats {
  if (_stats is EqualUnmodifiableMapView) return _stats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stats);
}

/// Document URLs: { gstCertificate, portfolioPhotos }
 final  Map<String, dynamic> _documents;
/// Document URLs: { gstCertificate, portfolioPhotos }
@override@JsonKey() Map<String, dynamic> get documents {
  if (_documents is EqualUnmodifiableMapView) return _documents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_documents);
}

// Bank details (stored encrypted in production)
@override@JsonKey() final  String bankAccountHolder;
@override@JsonKey() final  String bankName;
@override@JsonKey() final  String bankIfsc;
@override@JsonKey() final  String bankAccountNumberMasked;
@override final  DateTime? createdAt;

/// Create a copy of Agency
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgencyCopyWith<_Agency> get copyWith => __$AgencyCopyWithImpl<_Agency>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgencyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Agency&&(identical(other.agencyId, agencyId) || other.agencyId == agencyId)&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&(identical(other.teamSize, teamSize) || other.teamSize == teamSize)&&(identical(other.yearsExperience, yearsExperience) || other.yearsExperience == yearsExperience)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalTrips, totalTrips) || other.totalTrips == totalTrips)&&(identical(other.totalBookings, totalBookings) || other.totalBookings == totalBookings)&&const DeepCollectionEquality().equals(other._specialties, _specialties)&&const DeepCollectionEquality().equals(other._stats, _stats)&&const DeepCollectionEquality().equals(other._documents, _documents)&&(identical(other.bankAccountHolder, bankAccountHolder) || other.bankAccountHolder == bankAccountHolder)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.bankIfsc, bankIfsc) || other.bankIfsc == bankIfsc)&&(identical(other.bankAccountNumberMasked, bankAccountNumberMasked) || other.bankAccountNumberMasked == bankAccountNumberMasked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,agencyId,ownerUid,businessName,email,phone,description,logoUrl,coverImageUrl,verificationStatus,gstin,teamSize,yearsExperience,isVerified,rating,totalTrips,totalBookings,const DeepCollectionEquality().hash(_specialties),const DeepCollectionEquality().hash(_stats),const DeepCollectionEquality().hash(_documents),bankAccountHolder,bankName,bankIfsc,bankAccountNumberMasked,createdAt]);

@override
String toString() {
  return 'Agency(agencyId: $agencyId, ownerUid: $ownerUid, businessName: $businessName, email: $email, phone: $phone, description: $description, logoUrl: $logoUrl, coverImageUrl: $coverImageUrl, verificationStatus: $verificationStatus, gstin: $gstin, teamSize: $teamSize, yearsExperience: $yearsExperience, isVerified: $isVerified, rating: $rating, totalTrips: $totalTrips, totalBookings: $totalBookings, specialties: $specialties, stats: $stats, documents: $documents, bankAccountHolder: $bankAccountHolder, bankName: $bankName, bankIfsc: $bankIfsc, bankAccountNumberMasked: $bankAccountNumberMasked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AgencyCopyWith<$Res> implements $AgencyCopyWith<$Res> {
  factory _$AgencyCopyWith(_Agency value, $Res Function(_Agency) _then) = __$AgencyCopyWithImpl;
@override @useResult
$Res call({
 String agencyId, String ownerUid, String businessName, String email, String phone, String description, String logoUrl, String coverImageUrl, String verificationStatus, String gstin, String teamSize, int yearsExperience, bool isVerified, double rating, int totalTrips, int totalBookings, List<String> specialties, Map<String, dynamic> stats, Map<String, dynamic> documents, String bankAccountHolder, String bankName, String bankIfsc, String bankAccountNumberMasked, DateTime? createdAt
});




}
/// @nodoc
class __$AgencyCopyWithImpl<$Res>
    implements _$AgencyCopyWith<$Res> {
  __$AgencyCopyWithImpl(this._self, this._then);

  final _Agency _self;
  final $Res Function(_Agency) _then;

/// Create a copy of Agency
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agencyId = null,Object? ownerUid = null,Object? businessName = null,Object? email = null,Object? phone = null,Object? description = null,Object? logoUrl = null,Object? coverImageUrl = null,Object? verificationStatus = null,Object? gstin = null,Object? teamSize = null,Object? yearsExperience = null,Object? isVerified = null,Object? rating = null,Object? totalTrips = null,Object? totalBookings = null,Object? specialties = null,Object? stats = null,Object? documents = null,Object? bankAccountHolder = null,Object? bankName = null,Object? bankIfsc = null,Object? bankAccountNumberMasked = null,Object? createdAt = freezed,}) {
  return _then(_Agency(
agencyId: null == agencyId ? _self.agencyId : agencyId // ignore: cast_nullable_to_non_nullable
as String,ownerUid: null == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,coverImageUrl: null == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as String,gstin: null == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String,teamSize: null == teamSize ? _self.teamSize : teamSize // ignore: cast_nullable_to_non_nullable
as String,yearsExperience: null == yearsExperience ? _self.yearsExperience : yearsExperience // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalTrips: null == totalTrips ? _self.totalTrips : totalTrips // ignore: cast_nullable_to_non_nullable
as int,totalBookings: null == totalBookings ? _self.totalBookings : totalBookings // ignore: cast_nullable_to_non_nullable
as int,specialties: null == specialties ? _self._specialties : specialties // ignore: cast_nullable_to_non_nullable
as List<String>,stats: null == stats ? _self._stats : stats // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,documents: null == documents ? _self._documents : documents // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,bankAccountHolder: null == bankAccountHolder ? _self.bankAccountHolder : bankAccountHolder // ignore: cast_nullable_to_non_nullable
as String,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,bankIfsc: null == bankIfsc ? _self.bankIfsc : bankIfsc // ignore: cast_nullable_to_non_nullable
as String,bankAccountNumberMasked: null == bankAccountNumberMasked ? _self.bankAccountNumberMasked : bankAccountNumberMasked // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
