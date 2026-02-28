// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Agency _$AgencyFromJson(Map<String, dynamic> json) => _Agency(
  agencyId: json['agencyId'] as String,
  ownerUid: json['ownerUid'] as String,
  businessName: json['businessName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  description: json['description'] as String? ?? '',
  logoUrl: json['logoUrl'] as String? ?? '',
  coverImageUrl: json['coverImageUrl'] as String? ?? '',
  verificationStatus: json['verificationStatus'] as String? ?? 'pending',
  gstin: json['gstin'] as String? ?? '',
  teamSize: json['teamSize'] as String? ?? '',
  yearsExperience: (json['yearsExperience'] as num?)?.toInt() ?? 0,
  isVerified: json['isVerified'] as bool? ?? false,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  totalTrips: (json['totalTrips'] as num?)?.toInt() ?? 0,
  totalBookings: (json['totalBookings'] as num?)?.toInt() ?? 0,
  specialties:
      (json['specialties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  stats: json['stats'] as Map<String, dynamic>? ?? const {},
  documents: json['documents'] as Map<String, dynamic>? ?? const {},
  bankAccountHolder: json['bankAccountHolder'] as String? ?? '',
  bankName: json['bankName'] as String? ?? '',
  bankIfsc: json['bankIfsc'] as String? ?? '',
  bankAccountNumberMasked: json['bankAccountNumberMasked'] as String? ?? '',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AgencyToJson(_Agency instance) => <String, dynamic>{
  'agencyId': instance.agencyId,
  'ownerUid': instance.ownerUid,
  'businessName': instance.businessName,
  'email': instance.email,
  'phone': instance.phone,
  'description': instance.description,
  'logoUrl': instance.logoUrl,
  'coverImageUrl': instance.coverImageUrl,
  'verificationStatus': instance.verificationStatus,
  'gstin': instance.gstin,
  'teamSize': instance.teamSize,
  'yearsExperience': instance.yearsExperience,
  'isVerified': instance.isVerified,
  'rating': instance.rating,
  'totalTrips': instance.totalTrips,
  'totalBookings': instance.totalBookings,
  'specialties': instance.specialties,
  'stats': instance.stats,
  'documents': instance.documents,
  'bankAccountHolder': instance.bankAccountHolder,
  'bankName': instance.bankName,
  'bankIfsc': instance.bankIfsc,
  'bankAccountNumberMasked': instance.bankAccountNumberMasked,
  'createdAt': instance.createdAt?.toIso8601String(),
};
