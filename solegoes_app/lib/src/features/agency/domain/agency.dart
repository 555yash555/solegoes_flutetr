import 'package:freezed_annotation/freezed_annotation.dart';

part 'agency.freezed.dart';
part 'agency.g.dart';

@freezed
abstract class Agency with _$Agency {
  const factory Agency({
    required String agencyId,
    required String ownerUid,
    required String businessName,
    required String email,
    required String phone,
    @Default('') String description,
    @Default('') String logoUrl,
    @Default('') String coverImageUrl,
    /// verificationStatus: 'pending' | 'approved' | 'rejected'
    @Default('pending') String verificationStatus,
    @Default('') String gstin,
    @Default('') String teamSize,
    @Default(0) int yearsExperience,
    @Default(false) bool isVerified,
    @Default(0.0) double rating,
    @Default(0) int totalTrips,
    @Default(0) int totalBookings,
    @Default([]) List<String> specialties,
    /// Denormalized stats: { totalRevenue, activeBookings, completedTrips }
    @Default({}) Map<String, dynamic> stats,
    /// Document URLs: { gstCertificate, portfolioPhotos }
    @Default({}) Map<String, dynamic> documents,
    // Bank details (stored encrypted in production)
    @Default('') String bankAccountHolder,
    @Default('') String bankName,
    @Default('') String bankIfsc,
    @Default('') String bankAccountNumberMasked,
    DateTime? createdAt,
  }) = _Agency;

  factory Agency.fromJson(Map<String, dynamic> json) => _$AgencyFromJson(json);
}
