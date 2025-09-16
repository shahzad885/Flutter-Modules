// File: lib/pages/saved_sketches_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SavedSketchesPage extends StatefulWidget {
  const SavedSketchesPage({super.key});

  @override
  State<SavedSketchesPage> createState() => _SavedSketchesPageState();
}

class _SavedSketchesPageState extends State<SavedSketchesPage> {
  List<File> _sketches = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadSketches();
  }
  
  Future<void> _loadSketches() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = Directory(directory.path)
          .listSync()
          .where((item) => item.path.endsWith('.png') && item.path.contains('sketch_'))
          .map((item) => File(item.path))
          .toList();
      
      setState(() {
        _sketches = files;
      });
    } catch (e) {
      _showMessage('Error loading sketches: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _deleteSketch(File sketch) async {
    try {
      await sketch.delete();
      setState(() {
        _sketches.remove(sketch);
      });
      _showMessage('Sketch deleted');
    } catch (e) {
      _showMessage('Error deleting sketch: $e');
    }
  }
  
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Sketches'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sketches.isEmpty
              ? const Center(child: Text('No saved sketches'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: _sketches.length,
                  itemBuilder: (context, index) {
                    final sketch = _sketches[index];
                    final fileName = sketch.path.split('/').last;
                    
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppBar(
                                  title: Text(fileName),
                                  automaticallyImplyLeading: false,
                                  actions: [
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: Image.file(sketch),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              sketch,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteSketch(sketch),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}