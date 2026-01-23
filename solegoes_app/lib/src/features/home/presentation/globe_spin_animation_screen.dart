import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';

/// Globe spin animation screen shown after tapping "Spin the Globe"
/// Displays an engaging animation before navigating to the random trip
class GlobeSpinAnimationScreen extends StatefulWidget {
  final String tripId;

  const GlobeSpinAnimationScreen({
    super.key,
    required this.tripId,
  });

  @override
  State<GlobeSpinAnimationScreen> createState() => _GlobeSpinAnimationScreenState();
}

class _GlobeSpinAnimationScreenState extends State<GlobeSpinAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _sparkleController;

  late Animation<double> _spinAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _loadingMessages = [
    'Finding your adventure...',
    'Spinning the globe...',
    'Discovering new places...',
    'Almost there...',
  ];

  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();

    // Spin animation (continuous rotation)
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _spinAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.linear),
    );

    // Pulse animation (scale up and down)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Fade animation for text
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Sparkle animation
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Start text fade in
    _fadeController.forward();

    // Cycle through loading messages
    _cycleMessages();

    // Navigate after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        // Use go instead of push to replace the animation screen in the navigation stack
        // This ensures that when user presses back from trip detail, they go to home
        context.go('/trip/${widget.tripId}');
      }
    });
  }

  void _cycleMessages() {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && _currentMessageIndex < _loadingMessages.length - 1) {
        setState(() {
          _currentMessageIndex++;
        });
        _fadeController.reset();
        _fadeController.forward();
        _cycleMessages();
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.darkGradient,
        ),
        child: Stack(
          children: [
            // Sparkle particles in background
            ..._buildSparkles(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated globe
                  AnimatedBuilder(
                    animation: Listenable.merge([_spinAnimation, _pulseAnimation]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Transform.rotate(
                          angle: _spinAnimation.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '🌍',
                                style: TextStyle(fontSize: 80),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 48),

                  // Loading text with fade animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      _loadingMessages[_currentMessageIndex],
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Loading dots
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return AnimatedBuilder(
                          animation: _sparkleController,
                          builder: (context, child) {
                            final delay = index * 0.2;
                            final opacity = ((_sparkleController.value + delay) % 1.0) > 0.5 ? 1.0 : 0.3;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: opacity),
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSparkles() {
    final random = math.Random(42); // Fixed seed for consistent positions
    return List.generate(12, (index) {
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return Positioned(
        left: left,
        top: top,
        child: AnimatedBuilder(
          animation: _sparkleController,
          builder: (context, child) {
            final progress = (_sparkleController.value + delay) % 1.0;
            final opacity = progress < 0.5
                ? (progress * 2)
                : ((1 - progress) * 2);

            return Opacity(
              opacity: opacity.clamp(0.0, 0.6),
              child: Icon(
                Icons.star,
                size: 8 + (index % 3) * 4,
                color: AppColors.accentYellow,
              ),
            );
          },
        ),
      );
    });
  }
}
