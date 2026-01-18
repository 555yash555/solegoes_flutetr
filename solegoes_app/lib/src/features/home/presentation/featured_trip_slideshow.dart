import 'dart:async';
import 'package:flutter/material.dart';
import '../../trips/domain/trip.dart';
import '../../../common_widgets/trip_card.dart';
import '../../../theme/app_theme.dart';

class FeaturedTripSlideshow extends StatefulWidget {
  final List<Trip> trips;
  final Duration autoPlayInterval;

  const FeaturedTripSlideshow({
    super.key,
    required this.trips,
    this.autoPlayInterval = const Duration(seconds: 5),
  });

  @override
  State<FeaturedTripSlideshow> createState() => _FeaturedTripSlideshowState();
}

class _FeaturedTripSlideshowState extends State<FeaturedTripSlideshow> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (_currentPage < widget.trips.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.trips.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: widget.trips.length,
            itemBuilder: (context, index) {
              final trip = widget.trips[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FeaturedTripCard(
                  tripId: trip.tripId,
                  title: trip.title,
                  imageUrl: trip.imageUrl,
                  duration: '${trip.duration} Days',
                  location: trip.location,
                  price: trip.price,
                  isTrending: trip.isTrending,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.trips.length, (index) {
            final isActive = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.surfaceHover,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
