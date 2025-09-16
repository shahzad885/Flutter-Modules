// neumorphic_button.dart
import 'package:flutter/material.dart';

enum NeumorphicButtonStyle { flat, curved, soft }

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color shadowColor;
  final double blurRadius;
  final double spreadRadius;
  final Offset shadowOffset;
  final NeumorphicButtonStyle style;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Duration animationDuration;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width = 100.0,
    this.height = 48.0,
    this.backgroundColor = const Color.fromARGB(255, 244, 244, 241), // Light mode base from interactive button
    this.shadowColor = Colors.white,
    this.blurRadius = 12.0,
    this.spreadRadius = 2.0,
    this.shadowOffset = const Offset(6, 6),
    this.style = NeumorphicButtonStyle.flat,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  BorderRadius _getBorderRadius() {
    switch (widget.style) {
      case NeumorphicButtonStyle.flat:
        return BorderRadius.circular(widget.borderRadius);
      case NeumorphicButtonStyle.curved:
        return BorderRadius.circular(widget.height / 2);
      case NeumorphicButtonStyle.soft:
        return BorderRadius.circular(widget.borderRadius * 1.5);
    }
  }

  List<BoxShadow> _getBoxShadow() {
    if (_isPressed) {
      return [
        // Inset shadow effect
        BoxShadow(
          color: widget.shadowColor.withOpacity(0.8),
          offset: const Offset(2, 2),
          blurRadius: 4.0,
          spreadRadius: 1.0,
        ),
      ];
    }

    return [
      // Light shadow (top-left)
      BoxShadow(
        color: Colors.white.withOpacity(0.9),
        offset: -widget.shadowOffset,
        blurRadius: widget.blurRadius,
        spreadRadius: widget.spreadRadius,
      ),
      // Dark shadow (bottom-right)
      BoxShadow(
        color: widget.shadowColor.withOpacity(0.6),
        offset: widget.shadowOffset,
        blurRadius: widget.blurRadius,
        spreadRadius: widget.spreadRadius,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: _getBorderRadius(),
          boxShadow: _getBoxShadow(),
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}