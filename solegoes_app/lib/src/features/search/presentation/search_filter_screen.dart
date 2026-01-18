import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/category_pill.dart';
import '../../../common_widgets/app_shimmer.dart';
import '../../trips/data/trip_repository.dart';
import '../domain/trip_filter.dart';

class SearchFilterScreen extends ConsumerStatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  DateTimeRange? _dateRange;
  RangeValues _budgetRange = const RangeValues(0, 200000);
  final Set<String> _selectedCategories = {};

  final double _minBudget = 0;
  final double _maxBudget = 200000;



  // No more hardcoded categories


  void _handleApply() {
    final filter = TripFilter(
      dateRange: _dateRange,
      budgetRange: _budgetRange,
      categories: _selectedCategories.toList(),
    );
    context.push('/search/results', extra: filter);
  }

  void _handleReset() {
    setState(() {
      _dateRange = null;
      _budgetRange = RangeValues(_minBudget, _maxBudget);
      _selectedCategories.clear();
    });
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: AppTheme.darkTheme.copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.bgSurface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: const Text('Filters'),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(LucideIcons.x, size: 24),
        ),
        actions: [
          TextButton(
            onPressed: _handleReset,
            child: Text(
              'Reset',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dates Section
                  _buildSectionTitle('DATES'),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _selectDateRange,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceOverlay,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.calendar,
                              size: 20, color: AppColors.textTertiary),
                          const SizedBox(width: 12),
                          Text(
                            _dateRange == null
                                ? 'Add dates'
                                : '${DateFormat('MMM d').format(_dateRange!.start)} - ${DateFormat('MMM d').format(_dateRange!.end)}',
                            style: AppTextStyles.body.copyWith(
                              color: _dateRange == null
                                  ? AppColors.textPlaceholder
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Categories Section
                  _buildSectionTitle('CATEGORIES'),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, child) {
                      final allTripsAsync = ref.watch(allTripsProvider);
                      
                      return allTripsAsync.when(
                        data: (trips) {
                          final uniqueCategories = <String>{};
                          for (final trip in trips) {
                            uniqueCategories.addAll(trip.categories.where((c) => c.isNotEmpty));
                          }
                          final categories = uniqueCategories.toList()..sort();

                          if (categories.isEmpty) return const Text('No categories found', style: TextStyle(color: Colors.white54));

                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: categories.map((category) {
                              final isSelected = _selectedCategories.contains(category);
                              return CategoryPill(
                                label: category,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedCategories.remove(category);
                                    } else {
                                      _selectedCategories.add(category);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          );
                        },
                        loading: () => Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(4, (_) => const AppShimmer(width: 80, height: 32, borderRadius: 16)),
                        ),
                        error: (_,__) => const Text('Error loading categories'),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Budget Section
                  _buildSectionTitle('BUDGET RANGE'),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${_budgetRange.start.round().toString()}',
                        style: AppTextStyles.bodySmall,
                      ),
                      Text(
                        '₹${_budgetRange.end.round().toString()}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _budgetRange,
                    min: _minBudget,
                    max: _maxBudget,
                    divisions: 20,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.surfaceOverlay,
                    labels: RangeLabels(
                      '₹${_budgetRange.start.round()}',
                      '₹${_budgetRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() => _budgetRange = values);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom CTA
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: const BoxDecoration(
              color: AppColors.bgDeep,
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: AppButton(
              text: 'Show Trips',
              onPressed: _handleApply,
              isFullWidth: true,
              size: AppButtonSize.large,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.sectionTitle,
    );
  }
}
