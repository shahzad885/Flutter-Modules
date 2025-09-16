// neumorphic_progress_bar.dart
import 'package:flutter/material.dart';

class NeumorphicProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double width;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final Color shadowColor;
  final double blurRadius;
  final double spreadRadius;
  final Offset shadowOffset;
  final BorderRadius? borderRadius;

  const NeumorphicProgressBar({
    super.key,
    required this.progress,
    this.width = 200.0,
    this.height = 8.0,
    this.backgroundColor = const Color.fromARGB(255, 244, 244, 241),
    this.progressColor = const Color(0xFF7B68EE),
    this.shadowColor = Colors.white,
    this.blurRadius = 6.0,
    this.spreadRadius = 1.0,
    this.shadowOffset = const Offset(3, 3),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(height / 2);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          // Inner shadow effect for track
          BoxShadow(
            color: shadowColor.withOpacity(0.6),
            offset: const Offset(2, 2),
            blurRadius: 4.0,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Stack(
          children: [
            // Progress fill
            if (clampedProgress > 0)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: width * clampedProgress,
                  height: height,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: effectiveBorderRadius,
                    boxShadow: [
                      // Light highlight on progress
                      BoxShadow(
                        color: Colors.white.withOpacity(0.6),
                        offset: const Offset(-1, -1),
                        blurRadius: 2.0,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}