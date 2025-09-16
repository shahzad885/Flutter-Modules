// neumorphic_icon.dart
import 'package:flutter/material.dart';

class NeumorphicIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;
  final Color shadowColor;
  final double blurRadius;
  final double spreadRadius;
  final Offset shadowOffset;
  final bool isPressed;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const NeumorphicIcon({
    super.key,
    required this.icon,
    this.size = 48.0,
    this.iconSize = 24.0,
    this.backgroundColor = const Color.fromARGB(255, 244, 244, 241), // Light mode base from interactive button
    this.iconColor = const Color(0xFF8A96A3),
    this.shadowColor =  Colors.white,
    this.blurRadius = 12.0,
    this.spreadRadius = 2.0,
    this.shadowOffset = const Offset(6, 6),
    this.isPressed = false,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(size / 4),
          boxShadow: isPressed
              ? [
                  // Inset shadow effect for pressed state
                  BoxShadow(
                    color: shadowColor.withOpacity(0.8),
                    offset: const Offset(2, 2),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ]
              : [
                  // Light shadow (top-left)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: -shadowOffset,
                    blurRadius: blurRadius,
                    spreadRadius: spreadRadius,
                  ),
                  // Dark shadow (bottom-right)
                  BoxShadow(
                    color: shadowColor.withOpacity(0.6),
                    offset: shadowOffset,
                    blurRadius: blurRadius,
                    spreadRadius: spreadRadius,
                  ),
                ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}