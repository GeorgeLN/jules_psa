
// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, no_logic_in_create_state

import 'package:flutter/material.dart';

class WavePulse extends StatefulWidget {
  const WavePulse({super.key, required this.color});

  final Color color;

  @override
  _WavePulseState createState() => _WavePulseState(color: color);
}

class _WavePulseState extends State<WavePulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Color color;

  _WavePulseState({required this.color});

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => CustomPaint(
        painter: WavePainter(scale: _animation.value, color: color),
        size: Size(100, 100),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double scale;
  final Color color;

  WavePainter({required this.scale, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const waveCount = 4;
    for (int i = 0; i < waveCount; i++) {
      final radius = (size.width / 24) * (i + 1) * scale;
      paint.color = color.withOpacity(1 - i * 0.2);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}
