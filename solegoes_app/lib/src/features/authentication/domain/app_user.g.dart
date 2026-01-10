// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String? ?? '',
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  photoUrl: json['photoUrl'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  bio: json['bio'] as String?,
  city: json['city'] as String?,
  gender: json['gender'] as String?,
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  personalityTraits:
      (json['personalityTraits'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  interests:
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  budgetRange: json['budgetRange'] as String?,
  travelStyle: json['travelStyle'] as String?,
  isProfileComplete: json['isProfileComplete'] as bool? ?? false,
  isPreferencesComplete: json['isPreferencesComplete'] as bool? ?? false,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'isEmailVerified': instance.isEmailVerified,
  'photoUrl': instance.photoUrl,
  'phoneNumber': instance.phoneNumber,
  'bio': instance.bio,
  'city': instance.city,
  'gender': instance.gender,
  'birthDate': instance.birthDate?.toIso8601String(),
  'personalityTraits': instance.personalityTraits,
  'interests': instance.interests,
  'budgetRange': instance.budgetRange,
  'travelStyle': instance.travelStyle,
  'isProfileComplete': instance.isProfileComplete,
  'isPreferencesComplete': instance.isPreferencesComplete,
};
