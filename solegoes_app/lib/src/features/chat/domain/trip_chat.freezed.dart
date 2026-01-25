// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripChat {

 String get chatId; String get tripId; String get tripTitle; String get tripLocation;@JsonKey(name: 'tripStartDate') int get tripStartDateMillis;@JsonKey(name: 'tripEndDate') int get tripEndDateMillis; Map<String, bool> get participantIds; int get participantCount; String? get lastMessage;@JsonKey(name: 'lastMessageTime') int? get lastMessageTimeMillis; String? get lastMessageSenderId;@JsonKey(name: 'createdAt') int get createdAtMillis;
/// Create a copy of TripChat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripChatCopyWith<TripChat> get copyWith => _$TripChatCopyWithImpl<TripChat>(this as TripChat, _$identity);

  /// Serializes this TripChat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripChat&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.tripTitle, tripTitle) || other.tripTitle == tripTitle)&&(identical(other.tripLocation, tripLocation) || other.tripLocation == tripLocation)&&(identical(other.tripStartDateMillis, tripStartDateMillis) || other.tripStartDateMillis == tripStartDateMillis)&&(identical(other.tripEndDateMillis, tripEndDateMillis) || other.tripEndDateMillis == tripEndDateMillis)&&const DeepCollectionEquality().equals(other.participantIds, participantIds)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageTimeMillis, lastMessageTimeMillis) || other.lastMessageTimeMillis == lastMessageTimeMillis)&&(identical(other.lastMessageSenderId, lastMessageSenderId) || other.lastMessageSenderId == lastMessageSenderId)&&(identical(other.createdAtMillis, createdAtMillis) || other.createdAtMillis == createdAtMillis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatId,tripId,tripTitle,tripLocation,tripStartDateMillis,tripEndDateMillis,const DeepCollectionEquality().hash(participantIds),participantCount,lastMessage,lastMessageTimeMillis,lastMessageSenderId,createdAtMillis);

@override
String toString() {
  return 'TripChat(chatId: $chatId, tripId: $tripId, tripTitle: $tripTitle, tripLocation: $tripLocation, tripStartDateMillis: $tripStartDateMillis, tripEndDateMillis: $tripEndDateMillis, participantIds: $participantIds, participantCount: $participantCount, lastMessage: $lastMessage, lastMessageTimeMillis: $lastMessageTimeMillis, lastMessageSenderId: $lastMessageSenderId, createdAtMillis: $createdAtMillis)';
}


}

/// @nodoc
abstract mixin class $TripChatCopyWith<$Res>  {
  factory $TripChatCopyWith(TripChat value, $Res Function(TripChat) _then) = _$TripChatCopyWithImpl;
@useResult
$Res call({
 String chatId, String tripId, String tripTitle, String tripLocation,@JsonKey(name: 'tripStartDate') int tripStartDateMillis,@JsonKey(name: 'tripEndDate') int tripEndDateMillis, Map<String, bool> participantIds, int participantCount, String? lastMessage,@JsonKey(name: 'lastMessageTime') int? lastMessageTimeMillis, String? lastMessageSenderId,@JsonKey(name: 'createdAt') int createdAtMillis
});




}
/// @nodoc
class _$TripChatCopyWithImpl<$Res>
    implements $TripChatCopyWith<$Res> {
  _$TripChatCopyWithImpl(this._self, this._then);

  final TripChat _self;
  final $Res Function(TripChat) _then;

/// Create a copy of TripChat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,Object? tripId = null,Object? tripTitle = null,Object? tripLocation = null,Object? tripStartDateMillis = null,Object? tripEndDateMillis = null,Object? participantIds = null,Object? participantCount = null,Object? lastMessage = freezed,Object? lastMessageTimeMillis = freezed,Object? lastMessageSenderId = freezed,Object? createdAtMillis = null,}) {
  return _then(_self.copyWith(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,tripTitle: null == tripTitle ? _self.tripTitle : tripTitle // ignore: cast_nullable_to_non_nullable
as String,tripLocation: null == tripLocation ? _self.tripLocation : tripLocation // ignore: cast_nullable_to_non_nullable
as String,tripStartDateMillis: null == tripStartDateMillis ? _self.tripStartDateMillis : tripStartDateMillis // ignore: cast_nullable_to_non_nullable
as int,tripEndDateMillis: null == tripEndDateMillis ? _self.tripEndDateMillis : tripEndDateMillis // ignore: cast_nullable_to_non_nullable
as int,participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageTimeMillis: freezed == lastMessageTimeMillis ? _self.lastMessageTimeMillis : lastMessageTimeMillis // ignore: cast_nullable_to_non_nullable
as int?,lastMessageSenderId: freezed == lastMessageSenderId ? _self.lastMessageSenderId : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
as String?,createdAtMillis: null == createdAtMillis ? _self.createdAtMillis : createdAtMillis // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TripChat].
extension TripChatPatterns on TripChat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripChat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripChat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripChat value)  $default,){
final _that = this;
switch (_that) {
case _TripChat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripChat value)?  $default,){
final _that = this;
switch (_that) {
case _TripChat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chatId,  String tripId,  String tripTitle,  String tripLocation, @JsonKey(name: 'tripStartDate')  int tripStartDateMillis, @JsonKey(name: 'tripEndDate')  int tripEndDateMillis,  Map<String, bool> participantIds,  int participantCount,  String? lastMessage, @JsonKey(name: 'lastMessageTime')  int? lastMessageTimeMillis,  String? lastMessageSenderId, @JsonKey(name: 'createdAt')  int createdAtMillis)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripChat() when $default != null:
return $default(_that.chatId,_that.tripId,_that.tripTitle,_that.tripLocation,_that.tripStartDateMillis,_that.tripEndDateMillis,_that.participantIds,_that.participantCount,_that.lastMessage,_that.lastMessageTimeMillis,_that.lastMessageSenderId,_that.createdAtMillis);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chatId,  String tripId,  String tripTitle,  String tripLocation, @JsonKey(name: 'tripStartDate')  int tripStartDateMillis, @JsonKey(name: 'tripEndDate')  int tripEndDateMillis,  Map<String, bool> participantIds,  int participantCount,  String? lastMessage, @JsonKey(name: 'lastMessageTime')  int? lastMessageTimeMillis,  String? lastMessageSenderId, @JsonKey(name: 'createdAt')  int createdAtMillis)  $default,) {final _that = this;
switch (_that) {
case _TripChat():
return $default(_that.chatId,_that.tripId,_that.tripTitle,_that.tripLocation,_that.tripStartDateMillis,_that.tripEndDateMillis,_that.participantIds,_that.participantCount,_that.lastMessage,_that.lastMessageTimeMillis,_that.lastMessageSenderId,_that.createdAtMillis);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chatId,  String tripId,  String tripTitle,  String tripLocation, @JsonKey(name: 'tripStartDate')  int tripStartDateMillis, @JsonKey(name: 'tripEndDate')  int tripEndDateMillis,  Map<String, bool> participantIds,  int participantCount,  String? lastMessage, @JsonKey(name: 'lastMessageTime')  int? lastMessageTimeMillis,  String? lastMessageSenderId, @JsonKey(name: 'createdAt')  int createdAtMillis)?  $default,) {final _that = this;
switch (_that) {
case _TripChat() when $default != null:
return $default(_that.chatId,_that.tripId,_that.tripTitle,_that.tripLocation,_that.tripStartDateMillis,_that.tripEndDateMillis,_that.participantIds,_that.participantCount,_that.lastMessage,_that.lastMessageTimeMillis,_that.lastMessageSenderId,_that.createdAtMillis);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripChat extends TripChat {
  const _TripChat({required this.chatId, required this.tripId, required this.tripTitle, required this.tripLocation, @JsonKey(name: 'tripStartDate') required this.tripStartDateMillis, @JsonKey(name: 'tripEndDate') required this.tripEndDateMillis, required final  Map<String, bool> participantIds, required this.participantCount, this.lastMessage, @JsonKey(name: 'lastMessageTime') this.lastMessageTimeMillis, this.lastMessageSenderId, @JsonKey(name: 'createdAt') required this.createdAtMillis}): _participantIds = participantIds,super._();
  factory _TripChat.fromJson(Map<String, dynamic> json) => _$TripChatFromJson(json);

@override final  String chatId;
@override final  String tripId;
@override final  String tripTitle;
@override final  String tripLocation;
@override@JsonKey(name: 'tripStartDate') final  int tripStartDateMillis;
@override@JsonKey(name: 'tripEndDate') final  int tripEndDateMillis;
 final  Map<String, bool> _participantIds;
@override Map<String, bool> get participantIds {
  if (_participantIds is EqualUnmodifiableMapView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_participantIds);
}

@override final  int participantCount;
@override final  String? lastMessage;
@override@JsonKey(name: 'lastMessageTime') final  int? lastMessageTimeMillis;
@override final  String? lastMessageSenderId;
@override@JsonKey(name: 'createdAt') final  int createdAtMillis;

/// Create a copy of TripChat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripChatCopyWith<_TripChat> get copyWith => __$TripChatCopyWithImpl<_TripChat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripChatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripChat&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.tripTitle, tripTitle) || other.tripTitle == tripTitle)&&(identical(other.tripLocation, tripLocation) || other.tripLocation == tripLocation)&&(identical(other.tripStartDateMillis, tripStartDateMillis) || other.tripStartDateMillis == tripStartDateMillis)&&(identical(other.tripEndDateMillis, tripEndDateMillis) || other.tripEndDateMillis == tripEndDateMillis)&&const DeepCollectionEquality().equals(other._participantIds, _participantIds)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageTimeMillis, lastMessageTimeMillis) || other.lastMessageTimeMillis == lastMessageTimeMillis)&&(identical(other.lastMessageSenderId, lastMessageSenderId) || other.lastMessageSenderId == lastMessageSenderId)&&(identical(other.createdAtMillis, createdAtMillis) || other.createdAtMillis == createdAtMillis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatId,tripId,tripTitle,tripLocation,tripStartDateMillis,tripEndDateMillis,const DeepCollectionEquality().hash(_participantIds),participantCount,lastMessage,lastMessageTimeMillis,lastMessageSenderId,createdAtMillis);

@override
String toString() {
  return 'TripChat(chatId: $chatId, tripId: $tripId, tripTitle: $tripTitle, tripLocation: $tripLocation, tripStartDateMillis: $tripStartDateMillis, tripEndDateMillis: $tripEndDateMillis, participantIds: $participantIds, participantCount: $participantCount, lastMessage: $lastMessage, lastMessageTimeMillis: $lastMessageTimeMillis, lastMessageSenderId: $lastMessageSenderId, createdAtMillis: $createdAtMillis)';
}


}

/// @nodoc
abstract mixin class _$TripChatCopyWith<$Res> implements $TripChatCopyWith<$Res> {
  factory _$TripChatCopyWith(_TripChat value, $Res Function(_TripChat) _then) = __$TripChatCopyWithImpl;
@override @useResult
$Res call({
 String chatId, String tripId, String tripTitle, String tripLocation,@JsonKey(name: 'tripStartDate') int tripStartDateMillis,@JsonKey(name: 'tripEndDate') int tripEndDateMillis, Map<String, bool> participantIds, int participantCount, String? lastMessage,@JsonKey(name: 'lastMessageTime') int? lastMessageTimeMillis, String? lastMessageSenderId,@JsonKey(name: 'createdAt') int createdAtMillis
});




}
/// @nodoc
class __$TripChatCopyWithImpl<$Res>
    implements _$TripChatCopyWith<$Res> {
  __$TripChatCopyWithImpl(this._self, this._then);

  final _TripChat _self;
  final $Res Function(_TripChat) _then;

/// Create a copy of TripChat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? tripId = null,Object? tripTitle = null,Object? tripLocation = null,Object? tripStartDateMillis = null,Object? tripEndDateMillis = null,Object? participantIds = null,Object? participantCount = null,Object? lastMessage = freezed,Object? lastMessageTimeMillis = freezed,Object? lastMessageSenderId = freezed,Object? createdAtMillis = null,}) {
  return _then(_TripChat(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,tripTitle: null == tripTitle ? _self.tripTitle : tripTitle // ignore: cast_nullable_to_non_nullable
as String,tripLocation: null == tripLocation ? _self.tripLocation : tripLocation // ignore: cast_nullable_to_non_nullable
as String,tripStartDateMillis: null == tripStartDateMillis ? _self.tripStartDateMillis : tripStartDateMillis // ignore: cast_nullable_to_non_nullable
as int,tripEndDateMillis: null == tripEndDateMillis ? _self.tripEndDateMillis : tripEndDateMillis // ignore: cast_nullable_to_non_nullable
as int,participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageTimeMillis: freezed == lastMessageTimeMillis ? _self.lastMessageTimeMillis : lastMessageTimeMillis // ignore: cast_nullable_to_non_nullable
as int?,lastMessageSenderId: freezed == lastMessageSenderId ? _self.lastMessageSenderId : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
as String?,createdAtMillis: null == createdAtMillis ? _self.createdAtMillis : createdAtMillis // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
