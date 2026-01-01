import 'package:flutter/material.dart';

class GlowingMarker extends StatelessWidget {
  final bool isSelected;
  final bool isAiGenerated;

  const GlowingMarker({
    super.key,
    this.isSelected = false,
    this.isAiGenerated = false,
  });

  @override
  Widget build(BuildContext context) {
    // AI artifacts are green, others are gold (tertiary color)
    final baseColor =
        isAiGenerated ? Colors.greenAccent : Theme.of(context).colorScheme.tertiary;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 50 : 30,
        height: isSelected ? 50 : 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: baseColor,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: baseColor.withOpacity(0.8),
                    blurRadius: 12.0,
                    spreadRadius: 4.0,
                  ),
                  BoxShadow(
                    color: baseColor.withOpacity(0.6),
                    blurRadius: 20.0,
                    spreadRadius: 8.0,
                  ),
                ]
              : [
                  // Add a subtle shadow even when not selected
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  )
                ],
        ),
        child: Icon(
          isAiGenerated ? Icons.computer : Icons.location_on,
          color: isAiGenerated ? Colors.black87 : Colors.white,
          size: isSelected ? 25 : 18,
        ),
      ),
    );
  }
}
