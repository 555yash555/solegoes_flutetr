import 'package:cloud_firestore/cloud_firestore.dart';

/// Trip model representing a travel package
class Trip {
  final String tripId;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> imageUrls;
  final String location;
  final int duration; // in days
  final double price;
  final List<String> categories;
  final String groupSize;
  final double rating;
  final int reviewCount;
  final String agencyId;
  final String agencyName;
  final bool isVerifiedAgency;
  final String status; // 'pending_approval', 'live', 'rejected', 'completed'
  final List<String> inclusions;
  final List<Map<String, dynamic>> itinerary;
  final bool isTrending;
  final bool isFeatured;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Trip({
    required this.tripId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.imageUrls,
    required this.location,
    required this.duration,
    required this.price,
    required this.categories,
    required this.groupSize,
    required this.rating,
    required this.reviewCount,
    required this.agencyId,
    required this.agencyName,
    required this.isVerifiedAgency,
    required this.status,
    required this.inclusions,
    required this.itinerary,
    this.isTrending = false,
    this.isFeatured = false,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['tripId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.cast<String>() ?? [],
      location: json['location'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      categories: (json['categories'] as List<dynamic>?)?.cast<String>() ?? [],
      groupSize: json['groupSize'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      agencyId: json['agencyId'] as String? ?? '',
      agencyName: json['agencyName'] as String? ?? '',
      isVerifiedAgency: json['isVerifiedAgency'] as bool? ?? false,
      status: json['status'] as String? ?? 'pending_approval',
      inclusions: (json['inclusions'] as List<dynamic>?)?.cast<String>() ?? [],
      itinerary: (json['itinerary'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      isTrending: json['isTrending'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      startDate: _parseTimestamp(json['startDate']),
      endDate: _parseTimestamp(json['endDate']),
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'location': location,
      'duration': duration,
      'price': price,
      'categories': categories,
      'groupSize': groupSize,
      'rating': rating,
      'reviewCount': reviewCount,
      'agencyId': agencyId,
      'agencyName': agencyName,
      'isVerifiedAgency': isVerifiedAgency,
      'status': status,
      'inclusions': inclusions,
      'itinerary': itinerary,
      'isTrending': isTrending,
      'isFeatured': isFeatured,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  static DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.tryParse(timestamp);
    }
    return null;
  }

  Trip copyWith({
    String? tripId,
    String? title,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
    String? location,
    int? duration,
    double? price,
    List<String>? categories,
    String? groupSize,
    double? rating,
    int? reviewCount,
    String? agencyId,
    String? agencyName,
    bool? isVerifiedAgency,
    String? status,
    List<String>? inclusions,
    List<Map<String, dynamic>>? itinerary,
    bool? isTrending,
    bool? isFeatured,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Trip(
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      categories: categories ?? this.categories,
      groupSize: groupSize ?? this.groupSize,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      agencyId: agencyId ?? this.agencyId,
      agencyName: agencyName ?? this.agencyName,
      isVerifiedAgency: isVerifiedAgency ?? this.isVerifiedAgency,
      status: status ?? this.status,
      inclusions: inclusions ?? this.inclusions,
      itinerary: itinerary ?? this.itinerary,
      isTrending: isTrending ?? this.isTrending,
      isFeatured: isFeatured ?? this.isFeatured,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
