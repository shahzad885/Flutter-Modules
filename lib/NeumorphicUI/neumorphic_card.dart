import 'package:flutter/material.dart';
import 'package:inner_shadow_widget/inner_shadow_widget.dart';

enum NeumorphicCardType { elevated, inset }

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color shadow1Color; // dark
  final Color shadow2Color; // light
  final double blurRadius;
  final Offset shadowOffset;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final NeumorphicCardType type;
  final VoidCallback? onTap;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.width = 200.0,
    this.height = 170.0,
    this.backgroundColor =const Color(0xFFE0E5EC),
    this.shadow1Color = const Color(0xFFA3B1C6), // deeper dark
    this.shadow2Color = Colors.white,
    this.blurRadius = 12.0,
    this.shadowOffset = const Offset(6, 6),
    this.borderRadius,
    this.padding = const EdgeInsets.all(3.0),
    this.margin = const EdgeInsets.all(8.0),
    this.type = NeumorphicCardType.elevated,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(20.0);

    final baseBox = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: type == NeumorphicCardType.elevated
            ? [
                BoxShadow(
                  color: shadow2Color,
                  offset: -shadowOffset,
                  blurRadius: blurRadius,
                ),
                BoxShadow(
                  color: shadow1Color,
                  offset: shadowOffset,
                  blurRadius: blurRadius,
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (type == NeumorphicCardType.inset) {
      return Container(
        margin: margin,
        child: InnerShadow(
          blur: blurRadius,
          offset: shadowOffset,
          color: shadow1Color.withOpacity(0.9), // Darker
          child: InnerShadow(
            blur: blurRadius,
            offset: -shadowOffset,
            color: shadow2Color.withOpacity(0.9), // Brighter
            child: baseBox,
          ),
        ),
      );
    }

    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: baseBox,
      ),
    );
  }
}
