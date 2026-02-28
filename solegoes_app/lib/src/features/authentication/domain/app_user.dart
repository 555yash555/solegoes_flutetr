import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    @Default('') String displayName,
    @Default(false) bool isEmailVerified,
    String? photoUrl,
    String? phoneNumber,
    // Profile fields
    String? bio,
    String? city,
    String? gender,
    DateTime? birthDate,
    @Default([]) List<String> personalityTraits,
    // Preferences
    @Default([]) List<String> interests,
    String? budgetRange,
    String? travelStyle,
    // Profile completion status
    @Default(false) bool isProfileComplete,
    @Default(false) bool isPreferencesComplete,
    // Role-based access: 'consumer' | 'agency' | 'superAdmin'
    // @Default ensures existing Firestore docs without this field stay consumer
    @Default('consumer') String role,
    // Only present for agency users
    String? agencyId,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
