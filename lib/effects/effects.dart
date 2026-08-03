import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class ConfettiEffect extends StatefulWidget {
  final bool trigger;
  final Duration duration;
  final VoidCallback? onComplete;

  const ConfettiEffect({
    super.key,
    required this.trigger,
    this.duration = const Duration(seconds: 3),
    this.onComplete,
  });

  @override
  State<ConfettiEffect> createState() => _ConfettiEffectState();
}

class _ConfettiEffectState extends State<ConfettiEffect> {
  late ConfettiController _controllerTop;
  late ConfettiController _controllerBottom;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controllerTop = ConfettiController(duration: widget.duration);
    _controllerBottom = ConfettiController(duration: widget.duration);
  }

  @override
  void didUpdateWidget(covariant ConfettiEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !_hasTriggered) {
      _hasTriggered = true;
      _controllerTop.play();
      _controllerBottom.play();
      Future.delayed(widget.duration, () {
        widget.onComplete?.call();
        _hasTriggered = false;
      });
    }
  }

  @override
  void dispose() {
    _controllerTop.dispose();
    _controllerBottom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerTop,
            blastDirection: pi / 2,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
              Colors.pink,
            ],
            numberOfParticles: 50,
            gravity: 0.3,
            emissionFrequency: 0.05,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _controllerBottom,
            blastDirection: -pi / 2,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
              Colors.pink,
            ],
            numberOfParticles: 50,
            gravity: -0.3,
            emissionFrequency: 0.05,
          ),
        ),
      ],
    );
  }
}

class ParticleEffect extends StatefulWidget {
  final List<Particle> particles;
  final Size canvasSize;

  const ParticleEffect({
    super.key,
    required this.particles,
    required this.canvasSize,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = List.from(widget.particles);
    _controller = AnimationController(duration: const Duration(milliseconds: 16), vsync: this)
      ..addListener(_updateParticles)
      ..repeat();
  }

  void _updateParticles() {
    setState(() {
      _particles = _particles.map((p) => p.update()).where((p) => p.life > 0).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(particles: _particles),
      size: widget.canvasSize,
    );
  }
}

class Particle {
  final Offset position;
  final Offset velocity;
  final Color color;
  final double size;
  final double life;
  final double maxLife;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
    required this.maxLife,
  });

  Particle update() {
    return Particle(
      position: position + velocity,
      velocity: Offset(velocity.dx * 0.98, velocity.dy + 0.1),
      color: color.withValues(alpha: life / maxLife),
      size: size * (life / maxLife),
      life: life - 1,
      maxLife: maxLife,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  _ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ScreenShakeEffect extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final Duration duration;
  final double intensity;

  const ScreenShakeEffect({
    super.key,
    required this.child,
    required this.trigger,
    this.duration = const Duration(milliseconds: 300),
    this.intensity = 10.0,
  });

  @override
  State<ScreenShakeEffect> createState() => _ScreenShakeEffectState();
}

class _ScreenShakeEffectState extends State<ScreenShakeEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
  }

  @override
  void didUpdateWidget(covariant ScreenShakeEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !_hasTriggered) {
      _hasTriggered = true;
      _controller.forward(from: 0).whenComplete(() {
        _hasTriggered = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shakeX = sin(_controller.value * 20 * pi) * widget.intensity * (1 - _controller.value);
        return Transform.translate(
          offset: Offset(shakeX, 0),
          child: widget.child,
        );
      },
    );
  }
}

class GhostTrailEffect extends StatelessWidget {
  final List<Offset> positions;
  final Color color;
  final double strokeWidth;

  const GhostTrailEffect({
    super.key,
    required this.positions,
    required this.color,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GhostTrailPainter(positions: positions, color: color, strokeWidth: strokeWidth),
      size: Size.infinite,
    );
  }
}

class _GhostTrailPainter extends CustomPainter {
  final List<Offset> positions;
  final Color color;
  final double strokeWidth;

  _GhostTrailPainter({
    required this.positions,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 1; i < positions.length; i++) {
      final opacity = (i / positions.length).clamp(0.1, 1.0);
      paint.color = color.withValues(alpha: opacity);
      canvas.drawLine(positions[i - 1], positions[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}