// pagination_point.dart
import 'package:flutter/material.dart';

class NeumorphicPaginationPoint extends StatelessWidget {
  final bool isActive;
  final double size;
  final Color backgroundColor;
  final Color shadowColor;
  final Color activeColor;
  final double blurRadius;
  final double spreadRadius;
  final Offset shadowOffset;
  final VoidCallback? onTap;

  const NeumorphicPaginationPoint({
    super.key,
    this.isActive = false,
    this.size = 12.0,
       this.backgroundColor = const Color.fromARGB(255, 234, 234, 232), // Light mode base from interactive button

    this.shadowColor =  const Color.fromARGB(141, 255, 255, 255),
    this.activeColor = const Color(0xFF7B68EE),
    this.blurRadius = 8.0,
    this.spreadRadius = 2.0,
    this.shadowOffset = const Offset(4, 4),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isActive ? activeColor : backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            // Light shadow (top-left)
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
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
      ),
    );
  }
}