import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sky/Sonia%20project/TextToSpeach.dart';

class StoryGeneratorScreen extends StatefulWidget {
  const StoryGeneratorScreen({super.key});

  @override
  State<StoryGeneratorScreen> createState() => _StoryGeneratorScreenState();
}

class _StoryGeneratorScreenState extends State<StoryGeneratorScreen> {
  final TextEditingController _urlController = TextEditingController();
  String _generatedStory = '';
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _generateStory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _generatedStory = '';
    });

    final String imageUrl = _urlController.text.trim();
    if (imageUrl.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter an image URL';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://sonia-project.vercel.app/api/generate-story'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'imageUrl': imageUrl}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('story')) {
          setState(() {
            _generatedStory = data['story'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Unexpected response format from server';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to generate story. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: AppBar(
        title: const Text('Story Generator'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'story_icon',
                  child: Icon(Icons.auto_stories_rounded, size: 64, color: theme.primaryColor),
                ),
                const SizedBox(height: 16),
                Text(
                  "Turn your image into a story!",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.record_voice_over_rounded),
                  label: const Text('Text to Speech'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade100,
                    foregroundColor: Colors.deepPurple.shade700,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TextToSpeechScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: 'Enter Image URL',
                    hintText: 'https://example.com/image.jpg',
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.blue.shade200),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _urlController.clear(),
                    ),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _isLoading ? null : _generateStory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text('Generate Story', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_generatedStory.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text(
                    'Generated Story:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _generatedStory,
                        style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}