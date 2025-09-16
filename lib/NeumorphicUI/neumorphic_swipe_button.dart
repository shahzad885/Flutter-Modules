// neumorphic_swipe_button.dart
import 'package:flutter/material.dart';

class NeumorphicSwipeButton extends StatefulWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final Color thumbColor;
  final Color shadowColor;
  final Widget? child;
  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final VoidCallback? onSwipeComplete;
  final double threshold; // 0.0 to 1.0, how far to swipe to complete
  final Duration animationDuration;

  const NeumorphicSwipeButton({
    super.key,
    this.width = 200.0,
    this.height = 48.0,
    this.backgroundColor = const Color.fromARGB(255, 244, 244, 241), // Light mode base from interactive button
    this.thumbColor = Colors.white,
    this.shadowColor = const Color(0xFFBEC8D1),
    this.child,
    this.icon = Icons.arrow_forward_ios,
    this.iconSize = 20.0,
    this.iconColor = const Color(0xFF8A96A3),
    this.onSwipeComplete,
    this.threshold = 0.8,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<NeumorphicSwipeButton> createState() => _NeumorphicSwipeButtonState();
}

class _NeumorphicSwipeButtonState extends State<NeumorphicSwipeButton> {
  double _dragPosition = 0.0;
  bool _isDragging = false;

  double get maxDragDistance => widget.width - widget.height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.height / 2),
        boxShadow: [
          // Inner shadow effect
          BoxShadow(
            color: widget.shadowColor.withOpacity(0.6),
            offset: const Offset(2, 2),
            blurRadius: 6.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background content
          if (widget.child != null)
            Center(child: widget.child!),
          
          // Draggable thumb
          AnimatedPositioned(
            duration: _isDragging ? Duration.zero : widget.animationDuration,
            left: _dragPosition,
            top: 4,
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _isDragging = true;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _dragPosition = (_dragPosition + details.delta.dx)
                      .clamp(0.0, maxDragDistance);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _isDragging = false;
                  
                  if (_dragPosition >= maxDragDistance * widget.threshold) {
                    // Complete the swipe
                    _dragPosition = maxDragDistance;
                    if (widget.onSwipeComplete != null) {
                      widget.onSwipeComplete!();
                    }
                  } else {
                    // Snap back
                    _dragPosition = 0.0;
                  }
                });
              },
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
                      offset: const Offset(-2, -2),
                      blurRadius: 6.0,
                      spreadRadius: 1.0,
                    ),
                    // Dark shadow (bottom-right)
                    BoxShadow(
                      color: widget.shadowColor.withOpacity(0.4),
                      offset: const Offset(3, 3),
                      blurRadius: 6.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    size: widget.iconSize,
                    color: widget.iconColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to reset the swipe button
  void reset() {
    setState(() {
      _dragPosition = 0.0;
    });
  }
}