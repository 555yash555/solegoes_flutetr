// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Trip _$TripFromJson(Map<String, dynamic> json) => _Trip(
  tripId: json['tripId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String,
  imageUrls: (json['imageUrls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  location: json['location'] as String,
  duration: (json['duration'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  categories: (json['categories'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  groupSize: json['groupSize'] as String,
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  agencyId: json['agencyId'] as String,
  agencyName: json['agencyName'] as String,
  isVerifiedAgency: json['isVerifiedAgency'] as bool,
  status: json['status'] as String,
  inclusions: (json['inclusions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  itinerary: (json['itinerary'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  isTrending: json['isTrending'] as bool? ?? false,
  isFeatured: json['isFeatured'] as bool? ?? false,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$TripToJson(_Trip instance) => <String, dynamic>{
  'tripId': instance.tripId,
  'title': instance.title,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'imageUrls': instance.imageUrls,
  'location': instance.location,
  'duration': instance.duration,
  'price': instance.price,
  'categories': instance.categories,
  'groupSize': instance.groupSize,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'agencyId': instance.agencyId,
  'agencyName': instance.agencyName,
  'isVerifiedAgency': instance.isVerifiedAgency,
  'status': instance.status,
  'inclusions': instance.inclusions,
  'itinerary': instance.itinerary,
  'isTrending': instance.isTrending,
  'isFeatured': instance.isFeatured,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
