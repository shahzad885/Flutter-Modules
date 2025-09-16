import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SketchPage2 extends StatefulWidget {
  const SketchPage2({super.key});

  @override
  State<SketchPage2> createState() => _SketchPage2State();
}

class _SketchPage2State extends State<SketchPage2> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  bool _isColorPickerVisible = false;

  // Predefined colors for quick selection
  final List<Color> _colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.yellow,
  ];

  void _handleClearButtonPressed() {
    _signaturePadKey.currentState!.clear();
  }

  void _showColorPicker() {
    setState(() {
      _isColorPickerVisible = !_isColorPickerVisible;
    });
  }

  Widget _buildColorPalette() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          final color = _colors[index];
          final isSelected = _selectedColor == color;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
            },
            child: Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey.shade300,
                  width: isSelected ? 3.0 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 8.0,
                          spreadRadius: 2.0,
                        )
                      ]
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStrokeWidthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Brush Size: ${_strokeWidth.toInt()}px',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Slider(
            value: _strokeWidth,
            min: 1.0,
            max: 10.0,
            divisions: 9,
            activeColor: _selectedColor,
            onChanged: (value) {
              setState(() {
                _strokeWidth = value;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sketch Pad'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _handleClearButtonPressed,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tools panel
          Container(
            color: Colors.grey.shade50,
            child: Column(
              children: [
                // Color picker toggle and stroke width
                Row(
                  children: [
                    IconButton(
                      onPressed: _showColorPicker,
                      icon: Icon(
                        _isColorPickerVisible
                            ? Icons.keyboard_arrow_up
                            : Icons.palette,
                      ),
                      tooltip: 'Colors',
                    ),
                    Expanded(child: _buildStrokeWidthSelector()),
                    // Current color indicator
                    Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                  ],
                ),
                // Color palette (collapsible)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isColorPickerVisible ? 60 : 0,
                  child: _isColorPickerVisible ? _buildColorPalette() : null,
                ),
              ],
            ),
          ),
          // Signature pad
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SfSignaturePad(
                key: _signaturePadKey,
                strokeColor: _selectedColor,
                minimumStrokeWidth: _strokeWidth,
                maximumStrokeWidth: _strokeWidth,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
