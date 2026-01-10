import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';

/// Onboarding data model
class OnboardingSlide {
  final String imageUrl;
  final String badge;
  final String titleLine1;
  final String titleLine2;
  final String description;

  const OnboardingSlide({
    required this.imageUrl,
    required this.badge,
    required this.titleLine1,
    required this.titleLine2,
    required this.description,
  });
}

/// Onboarding screen with 3-slide card stack animation
/// Reference: designs/option15_onboarding.html
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  // Animation controllers for card exit
  late AnimationController _exitController;
  late Animation<Offset> _exitSlideAnimation;
  late Animation<double> _exitRotateAnimation;
  late Animation<double> _exitOpacityAnimation;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&q=80',
      badge: '🔥 #1 Travel App',
      titleLine1: 'Solo but',
      titleLine2: 'Never Alone.',
      description:
          'Join a community of travelers who turn solo trips into shared adventures.',
    ),
    OnboardingSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=800&q=80',
      badge: '✨ Verified Squads',
      titleLine1: 'Find Your',
      titleLine2: 'Travel Squad.',
      description:
          'Connect with like-minded people and create memories that last a lifetime.',
    ),
    OnboardingSlide(
      imageUrl:
          'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&q=80',
      badge: '🚀 Ready to fly',
      titleLine1: 'Ready for',
      titleLine2: 'Takeoff?',
      description:
          'Curated trips, secure payments, and zero hassle. Let\'s go!',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _exitController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _exitSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.5, 0),
    ).animate(CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeInOut,
    ));

    _exitRotateAnimation = Tween<double>(
      begin: 0,
      end: -0.3,
    ).animate(CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeInOut,
    ));

    _exitOpacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeIn,
    ));
  }

  void _nextSlide() {
    if (_currentIndex >= _slides.length - 1) {
      // Navigate to login
      context.go('/login');
      return;
    }

    _exitController.forward().then((_) {
      setState(() {
        _currentIndex++;
      });
      _exitController.reset();
    });
  }

  void _goToSlide(int index) {
    if (index == _currentIndex || index < 0 || index >= _slides.length) return;

    setState(() {
      _currentIndex = index;
    });
  }

  void _skipToLogin() {
    context.go('/login');
  }

  @override
  void dispose() {
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Column(
        children: [
          // Card stack area - 55% of screen
          Expanded(
            flex: 55,
            child: _buildCardStack(),
          ),
          // Content area - 45% of screen
          Expanded(
            flex: 45,
            child: _buildContentArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        // Swipe left to advance, swipe right to go back
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < -100) {
            _nextSlide();
          } else if (details.primaryVelocity! > 100 && _currentIndex > 0) {
            _goToSlide(_currentIndex - 1);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.only(top: 48),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Build cards in reverse order (back to front)
                for (int i = _slides.length - 1; i >= _currentIndex; i--)
                  _buildCard(i),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    final relativeIndex = index - _currentIndex;
    final isActive = relativeIndex == 0;

    // Calculate scale and offset based on position
    double scale = 1.0 - (relativeIndex * 0.08);
    double yOffset = relativeIndex * 20.0;
    double opacity = 1.0 - (relativeIndex * 0.35);
    double brightness = 1.0 - (relativeIndex * 0.25);

    Widget card = Transform.translate(
      offset: Offset(0, yOffset),
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.bottomCenter,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 1 - brightness),
              BlendMode.darken,
            ),
            child: _buildCardContent(index, isActive),
          ),
        ),
      ),
    );

    // Apply exit animation to active card
    if (isActive) {
      card = AnimatedBuilder(
        animation: _exitController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              _exitSlideAnimation.value.dx *
                  MediaQuery.of(context).size.width *
                  0.8,
              0,
            ),
            child: Transform.rotate(
              angle: _exitRotateAnimation.value,
              child: Opacity(
                opacity: _exitOpacityAnimation.value,
                child: child,
              ),
            ),
          );
        },
        child: card,
      );
    }

    return card;
  }

  Widget _buildCardContent(int index, bool isActive) {
    final slide = _slides[index];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.borderGlass),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 50,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.network(
              slide.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.bgSurface);
              },
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.bgDeep.withValues(alpha: 0.2),
                    AppColors.bgDeep.withValues(alpha: 0.8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Floating badge
            Positioned(
              top: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: isActive ? 1.0 : 0.0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 400),
                  offset: isActive ? Offset.zero : const Offset(0, -0.5),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      slide.badge,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentArea() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.bgDeep,
          ],
          stops: const [0.0, 0.1],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              // Text content
              Expanded(
                child: _buildTextContent(),
              ),

              // Indicators
              _buildIndicators(),
              const SizedBox(height: 24),

              // Buttons
              _buildContinueButton(),
              const SizedBox(height: 8),
              _buildSkipButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    final slide = _slides[_currentIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Column(
        key: ValueKey(_currentIndex),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slide.titleLine1,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.primaryGradient.createShader(bounds),
            child: Text(
              slide.titleLine2,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            slide.description,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        final isActive = index == _currentIndex;
        return GestureDetector(
          onTap: () => _goToSlide(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.textTertiary,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContinueButton() {
    final isLastSlide = _currentIndex == _slides.length - 1;

    return GestureDetector(
      onTap: _nextSlide,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastSlide ? 'Get Started' : 'Continue',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isLastSlide ? LucideIcons.rocket : LucideIcons.arrowRight,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return GestureDetector(
      onTap: _skipToLogin,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Skip to Login',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
