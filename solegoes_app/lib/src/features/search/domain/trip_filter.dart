import 'package:flutter/material.dart';

class TripFilter {
  final DateTimeRange? dateRange;
  final RangeValues? budgetRange;
  final List<String> categories;

  const TripFilter({
    this.dateRange,
    this.budgetRange,
    this.categories = const [],
  });

  TripFilter copyWith({
    DateTimeRange? dateRange,
    RangeValues? budgetRange,
    List<String>? categories,
  }) {
    return TripFilter(
      dateRange: dateRange ?? this.dateRange,
      budgetRange: budgetRange ?? this.budgetRange,
      categories: categories ?? this.categories,
    );
  }

  bool get isEmpty =>
      dateRange == null && (budgetRange == null) && categories.isEmpty;

  @override
  String toString() =>
      'TripFilter(dateRange: $dateRange, budgetRange: $budgetRange, categories: $categories)';
}
