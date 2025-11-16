import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoSlidesScreen extends ConsumerStatefulWidget {
  const InfoSlidesScreen({super.key});

  @override
  ConsumerState<InfoSlidesScreen> createState() => _InfoSlidesScreenState();
}

class _InfoSlidesScreenState extends ConsumerState<InfoSlidesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: "Win Your Morning",
      subtitle: "Hard-to-dismiss alarms that ensure you never oversleep again",
      imagePath: "assets/images/test.png",
    ),
    OnboardingSlide(
      title: "Build Unbreakable Discipline",
      subtitle: "Habit tracking system with smart reminders and streaks",
      imagePath: "assets/images/test.png",
    ),
    OnboardingSlide(
      title: "Smart Habits, with AI",
      subtitle: "AI coaching that adapts to your progress and motivates you",
      imagePath: "assets/images/test.png",
    ),
    OnboardingSlide(
      title: "Let's Go!",
      subtitle: "Start building the discipline you've always wanted",
      imagePath: "assets/images/test.png",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleOnboardingComplete();
    }
  }

  void _skipToEnd() {
    _handleOnboardingComplete();
  }

  Future<void> _handleOnboardingComplete() async {
    // Mark info slides as seen
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_info_slides', true);

    // Navigate to auth screen
    if (mounted) {
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Orange curved top section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size.width, size.height * 0.7),
              painter: CurvedTopPainter(
                color: theme.colorScheme.primary,
              ),
            ),
          ),

          // Phone mockup
          Positioned(
            top: size.height * 0.18,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.65,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: _buildPhoneMockup(_slides[index].imagePath, size),
                  );
                },
              ),
            ),
          ),

          // White bottom overlay (covers bottom half of phone)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size.width, size.height * 0.43),
              painter: CurvedBottomPainter(
                color: theme.colorScheme.surface,
              ),
            ),
          ),

          // Skip button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: TextButton(
                  onPressed: _skipToEnd,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Skip',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom content (text and buttons)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                40,
                24,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text content with animation
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.3, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      key: ValueKey<int>(_currentPage),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          _slides[_currentPage].title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _slides[_currentPage].subtitle,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Page indicators
                        _buildPageIndicators(theme),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Next/Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _slides.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Login link
                  TextButton(
                    onPressed: () => context.go('/auth/login'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    child: Text(
                      'Already have an account? Log In',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneMockup(String imagePath, Size screenSize) {
    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.phone_iphone,
          size: 200,
          color: Colors.grey[400],
        );
      },
    );
  }

  Widget _buildPageIndicators(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class OnboardingSlide {
  final String title;
  final String subtitle;
  final String imagePath;

  OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

/// Custom painter for curved orange top section
class CurvedTopPainter extends CustomPainter {
  final Color color;

  CurvedTopPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 60);

    // Create smooth downward curve
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 60,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvedTopPainter oldDelegate) => color != oldDelegate.color;
}

/// Custom painter for curved white bottom section
class CurvedBottomPainter extends CustomPainter {
  final Color color;

  CurvedBottomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);

    // Create downward curve (semicircle oriented downward)
    path.quadraticBezierTo(
      size.width / 2, // control point x (center)
      60, // control point y (curves downward)
      size.width, // end point x
      0, // end point y
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvedBottomPainter oldDelegate) =>
      color != oldDelegate.color;
}
