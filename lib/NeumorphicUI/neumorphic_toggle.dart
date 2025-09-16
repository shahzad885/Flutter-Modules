// neumorphic_toggle.dart
import 'package:flutter/material.dart';

class NeumorphicToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color activeColor;
  final Color shadowColor;
  final Color thumbColor;
  final double blurRadius;
  final double spreadRadius;
  final Offset shadowOffset;
  final Duration animationDuration;

  const NeumorphicToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.width = 60.0,
    this.height = 32.0,
    this.backgroundColor = const Color.fromARGB(255, 241, 241, 239), // Light mode base from interactive button
    this.activeColor = const Color(0xFFFF4444),
    this.shadowColor =  const Color.fromARGB(196, 255, 255, 255),
    this.thumbColor = Colors.white,
    this.blurRadius = 8.0,
    this.spreadRadius = 1.0,
    this.shadowOffset = const Offset(4, 4),
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<NeumorphicToggle> createState() => _NeumorphicToggleState();
}

class _NeumorphicToggleState extends State<NeumorphicToggle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged!(!widget.value);
        }
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.value ? widget.activeColor : widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.height / 2),
          boxShadow: [
            // Inner shadow effect
            BoxShadow(
              color: widget.shadowColor.withOpacity(0.6),
              offset: const Offset(2, 2),
              blurRadius: 4.0,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: widget.animationDuration,
              curve: Curves.easeInOut,
              left: widget.value 
                  ? widget.width - widget.height + 4 
                  : 4,
              top: 4,
              child: Container(
                width: widget.height - 8,
                height: widget.height - 8,
                decoration: BoxDecoration(
                  color: widget.thumbColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    // Light shadow (top-left)
                    BoxShadow(
                      color: Colors.white.withOpacity(0.9),
                      offset: -widget.shadowOffset / 2,
                      blurRadius: widget.blurRadius / 2,
                      spreadRadius: widget.spreadRadius,
                    ),
                    // Dark shadow (bottom-right)
                    BoxShadow(
                      color: widget.shadowColor.withOpacity(0.4),
                      offset: widget.shadowOffset / 2,
                      blurRadius: widget.blurRadius / 2,
                      spreadRadius: widget.spreadRadius,
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