import 'package:cloud_firestore/cloud_firestore.dart';

/// Trip style/package with different pricing
class TripStyle {
  final String styleId;
  final String name;
  final String description;
  final double price;
  final String accommodationType; // 'sharing-3', 'sharing-2', 'private'
  final List<String> mealOptions; // ['veg', 'non-veg', 'alcohol']
  final List<String> inclusions;

  TripStyle({
    required this.styleId,
    required this.name,
    required this.description,
    required this.price,
    required this.accommodationType,
    required this.mealOptions,
    required this.inclusions,
  });

  factory TripStyle.fromJson(Map<String, dynamic> json) {
    return TripStyle(
      styleId: json['styleId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      accommodationType: json['accommodationType'] as String? ?? 'sharing-3',
      mealOptions: (json['mealOptions'] as List<dynamic>?)?.cast<String>() ?? [],
      inclusions: (json['inclusions'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'styleId': styleId,
      'name': name,
      'description': description,
      'price': price,
      'accommodationType': accommodationType,
      'mealOptions': mealOptions,
      'inclusions': inclusions,
    };
  }
}

/// Boarding/Dropping point model
class TripPoint {
  final String name;
  final String address;
  final DateTime dateTime;

  TripPoint({
    required this.name,
    required this.address,
    required this.dateTime,
  });

  factory TripPoint.fromJson(Map<String, dynamic> json) {
    return TripPoint(
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      dateTime: _parseTimestamp(json['dateTime']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'dateTime': Timestamp.fromDate(dateTime),
    };
  }

  static DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is String) return DateTime.tryParse(timestamp);
    return null;
  }
}

/// Trip model representing a travel package
class Trip {
  final String tripId;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> imageUrls;
  final String location;
  final int duration; // in days
  final double price; // Base/starting price
  final List<TripStyle> pricingStyles; // Different package options
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
  final List<TripPoint> boardingPoints;
  final List<TripPoint> droppingPoints;
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
    this.pricingStyles = const [],
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
    this.boardingPoints = const [],
    this.droppingPoints = const [],
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
      pricingStyles: (json['pricingStyles'] as List<dynamic>?)
              ?.map((e) => TripStyle.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
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
      boardingPoints: (json['boardingPoints'] as List<dynamic>?)
              ?.map((e) => TripPoint.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      droppingPoints: (json['droppingPoints'] as List<dynamic>?)
              ?.map((e) => TripPoint.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
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
      'pricingStyles': pricingStyles.map((e) => e.toJson()).toList(),
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
      'boardingPoints': boardingPoints.map((e) => e.toJson()).toList(),
      'droppingPoints': droppingPoints.map((e) => e.toJson()).toList(),
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
    List<TripStyle>? pricingStyles,
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
    List<TripPoint>? boardingPoints,
    List<TripPoint>? droppingPoints,
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
      pricingStyles: pricingStyles ?? this.pricingStyles,
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
      boardingPoints: boardingPoints ?? this.boardingPoints,
      droppingPoints: droppingPoints ?? this.droppingPoints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
