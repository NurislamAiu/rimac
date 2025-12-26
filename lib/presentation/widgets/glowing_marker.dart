import 'package:flutter/material.dart';

class GlowingMarker extends StatefulWidget {
  final double size;

  const GlowingMarker({
    super.key,
    required this.size,
  });

  @override
  State<GlowingMarker> createState() => _GlowingMarkerState();
}

class _GlowingMarkerState extends State<GlowingMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.6 * _pulse.value),
                blurRadius: 8 * _pulse.value,
                spreadRadius: 2 * _pulse.value,
              ),
            ],
          ),
        );
      },
    );
  }
}
