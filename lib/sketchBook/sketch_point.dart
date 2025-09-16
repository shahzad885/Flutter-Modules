// File: lib/models/sketch_point.dart
import 'package:flutter/material.dart';

class SketchPoint {
  final Offset point;
  final Color color;
  final double strokeWidth;

  SketchPoint({
    required this.point,
    required this.color,
    required this.strokeWidth,
  });
}