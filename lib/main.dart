import 'dart:math';
import 'package:flutter/material.dart';

//todo
void main() {
  runApp(const SanaApp());
}

class SanaApp extends StatelessWidget {
  const SanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'For Sana 💕',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'serif',
      ),
      home: const SanaHomePage(),
    );
  }
}

// ─── Floating Particle ───────────────────────────────────────────────────────

class Particle {
  double x, y, size, speed, opacity, angle;
  String emoji;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
    required this.emoji,
  });
}

// ─── Main Page ───────────────────────────────────────────────────────────────

class SanaHomePage extends StatefulWidget {
  const SanaHomePage({super.key});

  @override
  State<SanaHomePage> createState() => _SanaHomePageState();
}

class _SanaHomePageState extends State<SanaHomePage>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _particleController;
  late AnimationController _fadeController;
  late AnimationController _floatController;
  late AnimationController _shimmerController;
  late AnimationController _petalController;

  late Animation<double> _heartScale;
  late Animation<double> _fadeIn;
  late Animation<double> _floatY;
  late Animation<double> _shimmer;

  final List<Particle> _particles = [];
  final Random _random = Random();
  final List<String> _emojis = ['💕', '🌹', '✨', '💖', '🌸', '💫', '🦋', '🌺'];

  int _currentMessageIndex = 0;
  bool _showMessage = false;

  final List<Map<String, String>> _messages = [
    {
      'title': 'My Universe',
      'body':
      'In every star that lights the night,\nI see your eyes so warm and bright.\nYou are the poetry my heart writes\nin every breath, in quiet nights.',
    },
    {
      'title': 'My Reason',
      'body':
      'Before you, life was just a story.\nWith you, it became a masterpiece.\nEvery morning I wake beside you\nis the greatest gift I will ever receive.',
    },
    {
      'title': 'Forever Yours',
      'body':
      'If I could travel time and space,\nI\'d choose every moment with your face.\nThrough every lifetime, every year —\nSana, you are why I am here.',
    },
    {
      'title': 'My Home',
      'body':
      'Home is not a place, it\'s a feeling.\nAnd every time I\'m near you,\nI am exactly where I belong —\nforever safe, forever in love with you.',
    },
  ];

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _heartScale = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatY = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _shimmer = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    _petalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _generateParticles();

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() => _showMessage = true);
    });
  }

  void _generateParticles() {
    for (int i = 0; i < 22; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 18 + 10,
        speed: _random.nextDouble() * 0.3 + 0.1,
        opacity: _random.nextDouble() * 0.5 + 0.2,
        angle: _random.nextDouble() * pi * 2,
        emoji: _emojis[_random.nextInt(_emojis.length)],
      ));
    }
  }

  void _nextMessage() {
    setState(() {
      _showMessage = false;
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      setState(() {
        _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
        _showMessage = true;
      });
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    _particleController.dispose();
    _fadeController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    _petalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D0015),
                  Color(0xFF1A0030),
                  Color(0xFF0A001A),
                  Color(0xFF1F0035),
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),

          // ── Radial glow center ──
          Center(
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF1493).withOpacity(0.12),
                    const Color(0xFFE040FB).withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Floating particles ──
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: ParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                  screenSize: size,
                ),
              );
            },
          ),

          // ── Main content ──
          FadeTransition(
            opacity: _fadeIn,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: isWide ? _buildWideLayout(size) : _buildNarrowLayout(size),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Wide layout (web) ──
  Widget _buildWideLayout(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: portrait + name
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTopBadge(),
                const SizedBox(height: 36),
                _buildPortraitCard(),
                const SizedBox(height: 28),
                _buildNameSection(),
              ],
            ),
          ),
        ),
        // Right: message + hearts
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeartBeat(),
                const SizedBox(height: 32),
                _buildMessageCard(),
                const SizedBox(height: 28),
                _buildBottomReason(),
                const SizedBox(height: 28),
                _buildNextButton(),
                const SizedBox(height: 24),
                _buildDots(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Narrow layout (mobile) ──
  Widget _buildNarrowLayout(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      child: Column(
        children: [
          _buildTopBadge(),
          const SizedBox(height: 28),
          _buildPortraitCard(),
          const SizedBox(height: 24),
          _buildNameSection(),
          const SizedBox(height: 32),
          _buildHeartBeat(),
          const SizedBox(height: 28),
          _buildMessageCard(),
          const SizedBox(height: 24),
          _buildBottomReason(),
          const SizedBox(height: 24),
          _buildNextButton(),
          const SizedBox(height: 20),
          _buildDots(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Top badge ──
  Widget _buildTopBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFFF1493).withOpacity(0.5), width: 1),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF1493).withOpacity(0.12),
            const Color(0xFFE040FB).withOpacity(0.08),
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _heartScale,
            builder: (_, __) => Transform.scale(
              scale: _heartScale.value,
              child: const Text('💕', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFF69B4), Color(0xFFE040FB), Color(0xFFFF1493)],
            ).createShader(bounds),
            child: const Text(
              'A message from your heart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text('💕', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // ── Portrait card ──
  Widget _buildPortraitCard() {
    return AnimatedBuilder(
      animation: _floatY,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _floatY.value),
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF1493), Color(0xFFE040FB), Color(0xFF9C27B0)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF1493).withOpacity(0.5),
                blurRadius: 40,
                spreadRadius: 8,
              ),
              BoxShadow(
                color: const Color(0xFFE040FB).withOpacity(0.3),
                blurRadius: 60,
                spreadRadius: 15,
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1A0030),
            ),
            child: const Center(
              child: Text(
                '🌹',
                style: TextStyle(fontSize: 80),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Name section ──
  Widget _buildNameSection() {
    return Column(
      children: [
        // S - A - N - A with shimmer
        AnimatedBuilder(
          animation: _shimmer,
          builder: (_, __) {
            return ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment(_shimmer.value - 1, 0),
                end: Alignment(_shimmer.value + 1, 0),
                colors: const [
                  Color(0xFFFF69B4),
                  Color(0xFFFFFFFF),
                  Color(0xFFE040FB),
                  Color(0xFFFF1493),
                  Color(0xFFFFD700),
                  Color(0xFFFF69B4),
                ],
              ).createShader(bounds),
              child: const Text(
                'S A N A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 18,
                  height: 1,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        const Text(
          '— My wife my everything —',
          style: TextStyle(
            color: Color(0xFFFF69B4),
            fontSize: 14,
            letterSpacing: 4,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  // ── Heartbeat ──
  Widget _buildHeartBeat() {
    return AnimatedBuilder(
      animation: _heartScale,
      builder: (_, __) => Transform.scale(
        scale: _heartScale.value,
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFF1493), Color(0xFFFF69B4), Color(0xFFFF1493)],
          ).createShader(bounds),
          child: const Text(
            '❤️',
            style: TextStyle(fontSize: 64, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ── Message card ──
  Widget _buildMessageCard() {
    final message = _messages[_currentMessageIndex];
    return AnimatedOpacity(
      opacity: _showMessage ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: AnimatedSlide(
        offset: _showMessage ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFFF1493).withOpacity(0.3),
              width: 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFF1493).withOpacity(0.08),
                const Color(0xFFE040FB).withOpacity(0.05),
                const Color(0xFF9C27B0).withOpacity(0.08),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote mark
              const Text(
                '"',
                style: TextStyle(
                  color: Color(0xFFFF1493),
                  fontSize: 48,
                  height: 0.8,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 6),
              // Title
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFF69B4), Color(0xFFE040FB)],
                ).createShader(bounds),
                child: Text(
                  message['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Body
              Text(
                message['body']!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.80),
                  fontSize: 15,
                  height: 1.75,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '— With all my love 💕',
                  style: TextStyle(
                    color: const Color(0xFFFF69B4).withOpacity(0.8),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom reason ──
  Widget _buildBottomReason() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌸', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'You make every ordinary day extraordinary',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 13,
                letterSpacing: 0.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text('🌸', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // ── Next button ──
  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _nextMessage,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF1493), Color(0xFFE040FB), Color(0xFF9C27B0)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF1493).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💌', style: TextStyle(fontSize: 16)),
            SizedBox(width: 10),
            Text(
              'Next love note',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 10),
            Text('💌', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // ── Dots indicator ──
  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_messages.length, (i) {
        final active = i == _currentMessageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: active
                ? const LinearGradient(
              colors: [Color(0xFFFF1493), Color(0xFFE040FB)],
            )
                : null,
            color: active ? null : Colors.white.withOpacity(0.2),
          ),
        );
      }),
    );
  }
}

// ─── Particle Painter ────────────────────────────────────────────────────────

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Size screenSize;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final p in particles) {
      final t = (p.y + progress * p.speed) % 1.0;
      final y = (1.0 - t) * size.height;
      final x = p.x * size.width + sin(progress * pi * 2 + p.angle) * 30;

      final opacity = t < 0.1
          ? t / 0.1 * p.opacity
          : t > 0.9
          ? (1 - t) / 0.1 * p.opacity
          : p.opacity;

      textPainter.text = TextSpan(
        text: p.emoji,
        style: TextStyle(
          fontSize: p.size,
          color: Colors.white.withOpacity(opacity),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}