import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/state/onboarding_state_machine.dart';

/// Intro page with 2 slides before questionnaire
class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({super.key});

  @override
  ConsumerState<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      // Go to second slide
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Use state machine to move to questionnaire
      ref.read(onboardingStateMachineProvider.notifier).completeIntro();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _nextPage,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
          children: [
            _buildSlide1(),
            _buildSlide2(),
          ],
        ),
      ),
    );
  }

  /// Slide 1: Welcome to StayHard
  Widget _buildSlide1() {
    return _Slide1Content(
      onComplete: _nextPage,
    );
  }

  /// Slide 2: Ready to start your life reset journey?
  Widget _buildSlide2() {
    return _Slide2Content(
      onComplete: _nextPage,
    );
  }
}

/// Animated Slide 1 Content
class _Slide1Content extends StatefulWidget {
  final VoidCallback onComplete;

  const _Slide1Content({required this.onComplete});

  @override
  State<_Slide1Content> createState() => _Slide1ContentState();
}

class _Slide1ContentState extends State<_Slide1Content>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _tapHintAnimation;

  String _welcomeText = '';
  String _stayHardText = '';
  bool _showTapHint = false;

  final String _fullWelcomeText = 'Welcome to';
  final String _fullStayHardText = 'StayHard';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo fade in animation (0-300ms)
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // Tap hint fade in animation (900-1000ms)
    _tapHintAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.9, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animations
    _controller.forward();

    // Typing animations with delays
    _animateWelcomeText();
  }

  void _animateWelcomeText() async {
    // Wait for logo to appear (300ms)
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // Type "Welcome to" (80ms per character)
    for (int i = 0; i <= _fullWelcomeText.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      setState(() {
        _welcomeText = _fullWelcomeText.substring(0, i);
      });
    }

    // Small pause (200ms)
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // Type "StayHard" (100ms per character)
    for (int i = 0; i <= _fullStayHardText.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() {
        _stayHardText = _fullStayHardText.substring(0, i);
      });
    }

    // Show tap hint
    if (!mounted) return;
    setState(() {
      _showTapHint = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onComplete,
      child: Stack(
        children: [
          // Enhanced gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0A0A),
                  Color(0xFF1A1A1A),
                  Color(0xFF252525),
                  Color(0xFF2D2D2D),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Glowing orange lines decoration
          CustomPaint(
            painter: _GlowingLinesPainter(),
            size: Size.infinite,
          ),

          // Blur overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/LOGO.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              size: 80,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Welcome text with typing animation
                  Text(
                    _welcomeText,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // StayHard text with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFFF6B35),
                        Color(0xFFFF8C5A),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      _stayHardText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  // Tap to continue hint
                  if (_showTapHint)
                    FadeTransition(
                      opacity: _tapHintAnimation,
                      child: const Text(
                        'Tap anywhere to continue',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
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
}

/// Slide 2: Ready to start your life reset journey?
class _Slide2Content extends StatefulWidget {
  final VoidCallback onComplete;

  const _Slide2Content({required this.onComplete});

  @override
  State<_Slide2Content> createState() => _Slide2ContentState();
}

class _Slide2ContentState extends State<_Slide2Content>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _buttonAnimation;

  String _readyText = '';
  String _lifeResetText = '';
  bool _showSubtitle = false;
  bool _showButton = false;

  final String _fullReadyText = 'Ready to start your';
  final String _fullLifeResetText = 'life reset journey?';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _subtitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 0.9, curve: Curves.easeIn),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.9, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    _animateText();
  }

  void _animateText() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    for (int i = 0; i <= _fullReadyText.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      setState(() {
        _readyText = _fullReadyText.substring(0, i);
      });
    }

    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;

    for (int i = 0; i <= _fullLifeResetText.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 90));
      if (!mounted) return;
      setState(() {
        _lifeResetText = _fullLifeResetText.substring(0, i);
      });
    }

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() {
      _showSubtitle = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _showButton = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Enhanced gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0A0A),
                Color(0xFF1A1A1A),
                Color(0xFF252525),
                Color(0xFF2D2D2D),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),

        // Glowing orange lines
        CustomPaint(
          painter: _GlowingLinesPainter(),
          size: Size.infinite,
        ),

        // Blur overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),

        // Content
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo (smaller)
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/LOGO.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              size: 60,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 64),

                  // Main question text
                  Text(
                    _readyText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // "life reset journey?" with orange accent
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        height: 1.4,
                      ),
                      children: _buildLifeResetSpans(),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Subtitle
                  if (_showSubtitle)
                    FadeTransition(
                      opacity: _subtitleAnimation,
                      child: const Text(
                        'Answer a few quick questions to get your\npersonalized transformation program',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          height: 1.5,
                        ),
                      ),
                    ),

                  const SizedBox(height: 80),

                  // Continue button
                  if (_showButton)
                    FadeTransition(
                      opacity: _buttonAnimation,
                      child: ElevatedButton(
                        onPressed: widget.onComplete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                          shadowColor:
                              const Color(0xFFFF6B35).withValues(alpha: 0.5),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Let\'s Begin',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<TextSpan> _buildLifeResetSpans() {
    final text = _lifeResetText;
    final journeyIndex = text.indexOf('journey');

    if (journeyIndex == -1) {
      return [
        TextSpan(
          text: text,
          style: const TextStyle(color: Colors.white),
        ),
      ];
    }

    final beforeJourney = text.substring(0, journeyIndex);
    final journey = text.substring(journeyIndex,
        journeyIndex + 'journey'.length.clamp(0, text.length - journeyIndex));
    final afterJourney = journeyIndex + 'journey'.length < text.length
        ? text.substring(journeyIndex + 'journey'.length)
        : '';

    return [
      TextSpan(
        text: beforeJourney,
        style: const TextStyle(color: Colors.white),
      ),
      TextSpan(
        text: journey,
        style: const TextStyle(
          color: Color(0xFFFF6B35),
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: afterJourney,
        style: const TextStyle(color: Colors.white),
      ),
    ];
  }
}

/// Custom painter for glowing orange lines
class _GlowingLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF6B35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    // Diagonal line 1
    final path1 = Path()
      ..moveTo(0, size.height * 0.15)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.25,
        size.width * 0.8,
        size.height * 0.12,
      );
    canvas.drawPath(path1, paint);

    // Diagonal line 2
    final path2 = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.48,
        size.width,
        size.height * 0.65,
      );
    canvas.drawPath(path2, paint);

    // Diagonal line 3
    final path3 = Path()
      ..moveTo(size.width, size.height * 0.28)
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.38,
        size.width * 0.45,
        size.height * 0.48,
      );
    canvas.drawPath(path3, paint);

    // Diagonal line 4
    final path4 = Path()
      ..moveTo(0, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.75,
        size.width * 0.6,
        size.height * 0.8,
      );
    canvas.drawPath(path4, paint);

    // Diagonal line 5
    final path5 = Path()
      ..moveTo(size.width * 0.5, 0)
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.2,
        size.width * 0.7,
        size.height * 0.35,
      );
    canvas.drawPath(path5, paint);

    // Accent lines
    final accentPaint = Paint()
      ..color = const Color(0xFFFF6B35).withValues(alpha: 0.35)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);

    canvas.drawLine(
      Offset(size.width * 0.12, 0),
      Offset(size.width * 0.12, size.height * 0.35),
      accentPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.88, size.height * 0.55),
      Offset(size.width * 0.88, size.height),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
