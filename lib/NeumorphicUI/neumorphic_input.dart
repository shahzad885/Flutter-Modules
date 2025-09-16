// neumorphic_input.dart
import 'package:flutter/material.dart';

class NeumorphicInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color shadowColor1;
  final Color shadowColor2;
  final Color textColor;
  final Color hintColor;
  final Color iconColor;
  final double blurRadius;
  final double spreadRadius;
  final Offset shadowOffset;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const NeumorphicInput({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.width = 300.0,
    this.height = 56.0,
    this.backgroundColor = const Color.fromARGB(255, 244, 244, 241), // Light mode base from interactive button
    this.shadowColor1 = const Color(0x4D9E9E9E), // Colors.grey.withOpacity(0.3)
    this.shadowColor2 = Colors.white,
    this.textColor = const Color(0xDE000000), // Colors.black87
    this.hintColor = const Color(0x8A000000), // Colors.black54
    this.iconColor = const Color(0x8A000000), // Colors.black54
    this.blurRadius = 10.0,
    this.spreadRadius = 1.0,
    this.shadowOffset = const Offset(4, 4),
    this.borderRadius,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.textStyle,
    this.hintStyle,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<NeumorphicInput> createState() => _NeumorphicInputState();
}

class _NeumorphicInputState extends State<NeumorphicInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(25.0);

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: _isFocused
            ? [
                // Focused state - inner shadow effect (pressed state)
                BoxShadow(
                  color: widget.shadowColor1.withOpacity(0.5),
                  offset: const Offset(3, 3),
                  blurRadius: 5,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: widget.shadowColor2.withOpacity(0.5),
                  offset: const Offset(-3, -3),
                  blurRadius: 5,
                  spreadRadius: 0,
                ),
              ]
            : [
                // Default state - outer shadow effect (not pressed)
                BoxShadow(
                  color: widget.shadowColor1,
                  offset: const Offset(4, 4),
                  blurRadius: widget.blurRadius,
                  spreadRadius: widget.spreadRadius,
                ),
                BoxShadow(
                  color: widget.shadowColor2,
                  offset: const Offset(-4, -4),
                  blurRadius: widget.blurRadius,
                  spreadRadius: widget.spreadRadius,
                ),
              ],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: widget.textStyle ??
            TextStyle(
              color: widget.textColor,
              fontSize: 16.0,
            ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          hintStyle: widget.hintStyle ??
              TextStyle(
                color: widget.hintColor,
                fontSize: 16.0,
              ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: widget.iconColor,
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: widget.onSuffixIconTap,
                  child: Icon(
                    widget.suffixIcon,
                    color: widget.iconColor,
                  ),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: widget.contentPadding,
        ),
      ),
    );
  }
}