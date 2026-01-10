// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get uid; String get email; String get displayName; bool get isEmailVerified; String? get photoUrl; String? get phoneNumber;// Profile fields
 String? get bio; String? get city; String? get gender; DateTime? get birthDate; List<String> get personalityTraits;// Preferences
 List<String> get interests; String? get budgetRange; String? get travelStyle;// Profile completion status
 bool get isProfileComplete; bool get isPreferencesComplete;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.city, city) || other.city == city)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&const DeepCollectionEquality().equals(other.personalityTraits, personalityTraits)&&const DeepCollectionEquality().equals(other.interests, interests)&&(identical(other.budgetRange, budgetRange) || other.budgetRange == budgetRange)&&(identical(other.travelStyle, travelStyle) || other.travelStyle == travelStyle)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.isPreferencesComplete, isPreferencesComplete) || other.isPreferencesComplete == isPreferencesComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,isEmailVerified,photoUrl,phoneNumber,bio,city,gender,birthDate,const DeepCollectionEquality().hash(personalityTraits),const DeepCollectionEquality().hash(interests),budgetRange,travelStyle,isProfileComplete,isPreferencesComplete);

@override
String toString() {
  return 'AppUser(uid: $uid, email: $email, displayName: $displayName, isEmailVerified: $isEmailVerified, photoUrl: $photoUrl, phoneNumber: $phoneNumber, bio: $bio, city: $city, gender: $gender, birthDate: $birthDate, personalityTraits: $personalityTraits, interests: $interests, budgetRange: $budgetRange, travelStyle: $travelStyle, isProfileComplete: $isProfileComplete, isPreferencesComplete: $isPreferencesComplete)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String displayName, bool isEmailVerified, String? photoUrl, String? phoneNumber, String? bio, String? city, String? gender, DateTime? birthDate, List<String> personalityTraits, List<String> interests, String? budgetRange, String? travelStyle, bool isProfileComplete, bool isPreferencesComplete
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? isEmailVerified = null,Object? photoUrl = freezed,Object? phoneNumber = freezed,Object? bio = freezed,Object? city = freezed,Object? gender = freezed,Object? birthDate = freezed,Object? personalityTraits = null,Object? interests = null,Object? budgetRange = freezed,Object? travelStyle = freezed,Object? isProfileComplete = null,Object? isPreferencesComplete = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,personalityTraits: null == personalityTraits ? _self.personalityTraits : personalityTraits // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,budgetRange: freezed == budgetRange ? _self.budgetRange : budgetRange // ignore: cast_nullable_to_non_nullable
as String?,travelStyle: freezed == travelStyle ? _self.travelStyle : travelStyle // ignore: cast_nullable_to_non_nullable
as String?,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,isPreferencesComplete: null == isPreferencesComplete ? _self.isPreferencesComplete : isPreferencesComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String displayName,  bool isEmailVerified,  String? photoUrl,  String? phoneNumber,  String? bio,  String? city,  String? gender,  DateTime? birthDate,  List<String> personalityTraits,  List<String> interests,  String? budgetRange,  String? travelStyle,  bool isProfileComplete,  bool isPreferencesComplete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.isEmailVerified,_that.photoUrl,_that.phoneNumber,_that.bio,_that.city,_that.gender,_that.birthDate,_that.personalityTraits,_that.interests,_that.budgetRange,_that.travelStyle,_that.isProfileComplete,_that.isPreferencesComplete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String displayName,  bool isEmailVerified,  String? photoUrl,  String? phoneNumber,  String? bio,  String? city,  String? gender,  DateTime? birthDate,  List<String> personalityTraits,  List<String> interests,  String? budgetRange,  String? travelStyle,  bool isProfileComplete,  bool isPreferencesComplete)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.uid,_that.email,_that.displayName,_that.isEmailVerified,_that.photoUrl,_that.phoneNumber,_that.bio,_that.city,_that.gender,_that.birthDate,_that.personalityTraits,_that.interests,_that.budgetRange,_that.travelStyle,_that.isProfileComplete,_that.isPreferencesComplete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String displayName,  bool isEmailVerified,  String? photoUrl,  String? phoneNumber,  String? bio,  String? city,  String? gender,  DateTime? birthDate,  List<String> personalityTraits,  List<String> interests,  String? budgetRange,  String? travelStyle,  bool isProfileComplete,  bool isPreferencesComplete)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.isEmailVerified,_that.photoUrl,_that.phoneNumber,_that.bio,_that.city,_that.gender,_that.birthDate,_that.personalityTraits,_that.interests,_that.budgetRange,_that.travelStyle,_that.isProfileComplete,_that.isPreferencesComplete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser implements AppUser {
  const _AppUser({required this.uid, required this.email, this.displayName = '', this.isEmailVerified = false, this.photoUrl, this.phoneNumber, this.bio, this.city, this.gender, this.birthDate, final  List<String> personalityTraits = const [], final  List<String> interests = const [], this.budgetRange, this.travelStyle, this.isProfileComplete = false, this.isPreferencesComplete = false}): _personalityTraits = personalityTraits,_interests = interests;
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String uid;
@override final  String email;
@override@JsonKey() final  String displayName;
@override@JsonKey() final  bool isEmailVerified;
@override final  String? photoUrl;
@override final  String? phoneNumber;
// Profile fields
@override final  String? bio;
@override final  String? city;
@override final  String? gender;
@override final  DateTime? birthDate;
 final  List<String> _personalityTraits;
@override@JsonKey() List<String> get personalityTraits {
  if (_personalityTraits is EqualUnmodifiableListView) return _personalityTraits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_personalityTraits);
}

// Preferences
 final  List<String> _interests;
// Preferences
@override@JsonKey() List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

@override final  String? budgetRange;
@override final  String? travelStyle;
// Profile completion status
@override@JsonKey() final  bool isProfileComplete;
@override@JsonKey() final  bool isPreferencesComplete;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.city, city) || other.city == city)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&const DeepCollectionEquality().equals(other._personalityTraits, _personalityTraits)&&const DeepCollectionEquality().equals(other._interests, _interests)&&(identical(other.budgetRange, budgetRange) || other.budgetRange == budgetRange)&&(identical(other.travelStyle, travelStyle) || other.travelStyle == travelStyle)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.isPreferencesComplete, isPreferencesComplete) || other.isPreferencesComplete == isPreferencesComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,isEmailVerified,photoUrl,phoneNumber,bio,city,gender,birthDate,const DeepCollectionEquality().hash(_personalityTraits),const DeepCollectionEquality().hash(_interests),budgetRange,travelStyle,isProfileComplete,isPreferencesComplete);

@override
String toString() {
  return 'AppUser(uid: $uid, email: $email, displayName: $displayName, isEmailVerified: $isEmailVerified, photoUrl: $photoUrl, phoneNumber: $phoneNumber, bio: $bio, city: $city, gender: $gender, birthDate: $birthDate, personalityTraits: $personalityTraits, interests: $interests, budgetRange: $budgetRange, travelStyle: $travelStyle, isProfileComplete: $isProfileComplete, isPreferencesComplete: $isPreferencesComplete)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String displayName, bool isEmailVerified, String? photoUrl, String? phoneNumber, String? bio, String? city, String? gender, DateTime? birthDate, List<String> personalityTraits, List<String> interests, String? budgetRange, String? travelStyle, bool isProfileComplete, bool isPreferencesComplete
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? isEmailVerified = null,Object? photoUrl = freezed,Object? phoneNumber = freezed,Object? bio = freezed,Object? city = freezed,Object? gender = freezed,Object? birthDate = freezed,Object? personalityTraits = null,Object? interests = null,Object? budgetRange = freezed,Object? travelStyle = freezed,Object? isProfileComplete = null,Object? isPreferencesComplete = null,}) {
  return _then(_AppUser(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,personalityTraits: null == personalityTraits ? _self._personalityTraits : personalityTraits // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,budgetRange: freezed == budgetRange ? _self.budgetRange : budgetRange // ignore: cast_nullable_to_non_nullable
as String?,travelStyle: freezed == travelStyle ? _self.travelStyle : travelStyle // ignore: cast_nullable_to_non_nullable
as String?,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,isPreferencesComplete: null == isPreferencesComplete ? _self.isPreferencesComplete : isPreferencesComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
