// File: lib/pages/sketch_page.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sky/sketchBook/Save_sketches_page.dart';
import 'package:sky/sketchBook/sketch_point.dart';
import 'package:uuid/uuid.dart';


class SketchPage extends StatefulWidget {
  const SketchPage({super.key});

  @override
  State<SketchPage> createState() => _SketchPageState();
}

class _SketchPageState extends State<SketchPage> {
  // Store the drawing points
  final List<List<SketchPoint>> _strokes = [];
  List<SketchPoint> _currentStroke = [];
  
  // Canvas properties
  Color _currentColor = Colors.black;
  double _currentStrokeWidth = 3.0;
  
  // For saving the drawing
  final GlobalKey _globalKey = GlobalKey();
  bool _isSaving = false;
  
  // Drawing tools
  final List<Color> _availableColors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sketch Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedSketchesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Drawing area
          RepaintBoundary(
            key: _globalKey,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _currentStroke = [];
                    _currentStroke.add(
                      SketchPoint(
                        point: details.localPosition,
                        color: _currentColor,
                        strokeWidth: _currentStrokeWidth,
                      ),
                    );
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _currentStroke.add(
                      SketchPoint(
                        point: details.localPosition,
                        color: _currentColor,
                        strokeWidth: _currentStrokeWidth,
                      ),
                    );
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    _strokes.add(_currentStroke);
                    _currentStroke = [];
                  });
                },
                child: CustomPaint(
                  painter: SketchPainter(
                    strokes: _strokes,
                    currentStroke: _currentStroke,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          
          // Loading indicator
          if (_isSaving)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          height: 70.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Color selector
              Wrap(
                spacing: 8.0,
                children: _availableColors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentColor = color;
                      });
                    },
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _currentColor == color
                              ? Colors.grey.shade300
                              : Colors.transparent,
                          width: 3.0,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              // Stroke width selector
              Row(
                children: [
                  const Text('Stroke: '),
                  Slider(
                    value: _currentStrokeWidth,
                    min: 1.0,
                    max: 10.0,
                    onChanged: (value) {
                      setState(() {
                        _currentStrokeWidth = value;
                      });
                    },
                  ),
                ],
              ),
              
              // Action buttons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _strokes.clear();
                        _currentStroke = [];
                      });
                    },
                    tooltip: 'Clear',
                  ),
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _saveSketch,
                    tooltip: 'Save',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveSketch() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Request storage permission
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
          status = await Permission.storage.status;
          if (!status.isGranted) {
            setState(() {
              _isSaving = false;
            });
            _showMessage('Storage permission is required to save sketches');
            return;
          }
        }
      }

      // Capture the drawing
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        // Save to local storage
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = 'sketch_${const Uuid().v4()}.png';
        final String path = '${directory.path}/$fileName';
        
        final File file = File(path);
        await file.writeAsBytes(pngBytes);
        
        _showMessage('Sketch saved successfully!');
      } else {
        _showMessage('Failed to save sketch');
      }
    } catch (e) {
      _showMessage('Error saving sketch: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
  
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class SketchPainter extends CustomPainter {
  final List<List<SketchPoint>> strokes;
  final List<SketchPoint> currentStroke;

  SketchPainter({required this.strokes, required this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }
    
    // Draw current stroke
    _drawStroke(canvas, currentStroke);
  }

  void _drawStroke(Canvas canvas, List<SketchPoint> stroke) {
    if (stroke.isEmpty) return;
    
    final Path path = Path();
    path.moveTo(stroke.first.point.dx, stroke.first.point.dy);
    
    for (int i = 1; i < stroke.length; i++) {
      path.lineTo(stroke[i].point.dx, stroke[i].point.dy);
    }
    
    final paint = Paint()
      ..color = stroke.first.color
      ..strokeWidth = stroke.first.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SketchPainter oldDelegate) => true;
}