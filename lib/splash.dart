import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
  static const _label = 'LC STUDIO';

  @override
  void initState() {
    super.initState();
    _c.forward().whenComplete(_go);
  }

  void _go() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => const HomePage(),
      transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
    ));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1424), Color(0xFF1B2F4B)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final t = _c.value;
              final logoT = Curves.easeOutCubic.transform((t / 0.278).clamp(0.0, 1.0));
              final textT = ((t - 0.278) / 0.444).clamp(0.0, 1.0);
              final n = (textT * _label.length).ceil();
              const style = TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 8,
                color: Colors.white,
              );
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: logoT,
                    child: Transform.scale(
                      scale: 0.8 + 0.2 * logoT,
                      child: SizedBox(
                        width: 112,
                        height: 112,
                        child: CustomPaint(painter: _LogoPainter()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: _label.substring(0, n), style: style),
                      TextSpan(
                        text: _label.substring(n),
                        style: style.copyWith(color: Colors.transparent),
                      ),
                    ]),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    canvas.scale(s.width / 100);
    final frame = RRect.fromRectAndRadius(
        const Rect.fromLTWH(4, 4, 92, 92), const Radius.circular(30));
    canvas.drawRRect(
      frame,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A66), Color(0xFF12233D)],
        ).createShader(const Rect.fromLTWH(0, 0, 100, 100)),
    );
    canvas.drawRRect(
      frame,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = const Color(0xFF4C7DFF),
    );
    final l = Path()
      ..moveTo(30, 28)
      ..lineTo(30, 70)
      ..lineTo(54, 70);
    canvas.drawPath(
      l,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white,
    );
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(62, 50), radius: 22),
      0.65,
      2 * math.pi - 1.3,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFFFF9F1C),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
