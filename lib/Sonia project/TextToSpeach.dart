import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:rive/rive.dart';
import 'dart:typed_data';

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({super.key});

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final TextEditingController _textController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Rive animation controller
  Artboard? _riveArtboard;
  RiveAnimationController? _talkController;
  RiveAnimationController? _idleController;
  RiveAnimationController? _successController;
  RiveAnimationController? _failController;
  
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedVoice = 'coral';
  bool _isPlaying = false;
  
  final List<String> _availableVoices = [
    'alloy',
    'echo',
    'fable',
    'onyx',
    'nova',
    'shimmer',
    'coral',
  ];
  
  @override
  void initState() {
    super.initState();
    _loadRiveFile();
    _setupAudioPlayerListeners();
  }
  
  void _setupAudioPlayerListeners() {
    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      
      setState(() {
        _isPlaying = isPlaying;
      });
      
      if (isPlaying && processingState == ProcessingState.ready) {
        _startTalkingAnimation();
      } else if (!isPlaying || processingState == ProcessingState.completed) {
        _stopTalkingAnimation();
      }
    });
    
    // Listen to position changes for more responsive animation
    _audioPlayer.positionStream.listen((position) {
      if (_isPlaying && _audioPlayer.duration != null) {
        // Keep talking animation active while playing
        if (_talkController?.isActive != true) {
          _startTalkingAnimation();
        }
      }
    });
  }
  
  Future<void> _loadRiveFile() async {
    try {
      // Load your Rive file - replace 'assets/avatar.riv' with your actual path
      final data = await DefaultAssetBundle.of(context).load('assets/login_screen_character.riv');
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      
      // Initialize animation controllers
      _talkController = SimpleAnimation('Talk');
      _idleController = SimpleAnimation('Idle'); // Assuming you have an idle state
      _successController = SimpleAnimation('success');
      _failController = SimpleAnimation('fail');
      
      // Start with idle animation
      artboard.addController(_idleController!);
      
      setState(() {
        _riveArtboard = artboard;
      });
    } catch (e) {
      print('Error loading Rive file: $e');
      // You might want to show an error message or use a fallback
    }
  }
  
  void _startTalkingAnimation() {
    if (_riveArtboard != null && _talkController != null) {
      // Remove idle controller and add talk controller
      if (_idleController?.isActive == true) {
        _riveArtboard!.removeController(_idleController!);
      }
      if (_successController?.isActive == true) {
        _riveArtboard!.removeController(_successController!);
      }
      if (_failController?.isActive == true) {
        _riveArtboard!.removeController(_failController!);
      }
      
      if (_talkController?.isActive != true) {
        _riveArtboard!.addController(_talkController!);
      }
    }
  }
  
  void _stopTalkingAnimation() {
    if (_riveArtboard != null) {
      // Remove talk controller and add idle controller
      if (_talkController?.isActive == true) {
        _riveArtboard!.removeController(_talkController!);
      }
      
      if (_idleController?.isActive != true) {
        _riveArtboard!.addController(_idleController!);
      }
    }
  }
  
  void _showSuccessAnimation() {
    if (_riveArtboard != null && _successController != null) {
      // Remove other controllers
      if (_talkController?.isActive == true) {
        _riveArtboard!.removeController(_talkController!);
      }
      if (_idleController?.isActive == true) {
        _riveArtboard!.removeController(_idleController!);
      }
      if (_failController?.isActive == true) {
        _riveArtboard!.removeController(_failController!);
      }
      
      _riveArtboard!.addController(_successController!);
      
      // Return to idle after success animation
      Future.delayed(const Duration(seconds: 2), () {
        if (_successController?.isActive == true) {
          _riveArtboard!.removeController(_successController!);
        }
        if (!_isPlaying) {
          _riveArtboard!.addController(_idleController!);
        }
      });
    }
  }
  
  void _showFailAnimation() {
    if (_riveArtboard != null && _failController != null) {
      // Remove other controllers
      if (_talkController?.isActive == true) {
        _riveArtboard!.removeController(_talkController!);
      }
      if (_idleController?.isActive == true) {
        _riveArtboard!.removeController(_idleController!);
      }
      if (_successController?.isActive == true) {
        _riveArtboard!.removeController(_successController!);
      }
      
      _riveArtboard!.addController(_failController!);
      
      // Return to idle after fail animation
      Future.delayed(const Duration(seconds: 2), () {
        if (_failController?.isActive == true) {
          _riveArtboard!.removeController(_failController!);
        }
        if (!_isPlaying) {
          _riveArtboard!.addController(_idleController!);
        }
      });
    }
  }
  
  @override
  void dispose() {
    _textController.dispose();
    _audioPlayer.dispose();
    _talkController?.dispose();
    _idleController?.dispose();
    _successController?.dispose();
    _failController?.dispose();
    super.dispose();
  }

  Future<void> _convertTextToSpeech() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter some text';
      });
      _showFailAnimation();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://sonia-project.vercel.app/api/text-to-speech'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'text': text,
          'voice': _selectedVoice,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = json.decode(response.body);
          if (data.containsKey('audio') && data.containsKey('format')) {
            final String base64Audio = data['audio'];
            print('Base64 audio length: ${base64Audio.length}');
            
            try {
              final Uint8List audioBytes = base64Decode(base64Audio);
              
              await _audioPlayer.setAudioSource(
                MyCustomSource(audioBytes),
              );
              
              await _audioPlayer.play();
              _showSuccessAnimation();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Playing audio with avatar animation...'),
                  duration: Duration(seconds: 2),
                ),
              );
            } catch (decodeError) {
              setState(() {
                _errorMessage = 'Failed to decode audio data: $decodeError';
              });
              _showFailAnimation();
              print('Base64 decode error: $decodeError');
            }
          } else {
            setState(() {
              _errorMessage = 'Invalid response format from server';
            });
            _showFailAnimation();
            print('Missing expected fields in response: $data');
          }
        } catch (jsonError) {
          setState(() {
            _errorMessage = 'Failed to parse server response: $jsonError';
          });
          _showFailAnimation();
          print('JSON parse error: $jsonError');
        }
      } else {
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          setState(() {
            _errorMessage = errorData['error'] ?? 'Failed to generate speech';
          });
          _showFailAnimation();
          print('Error details: ${errorData['details']}');
        } catch (e) {
          setState(() {
            _errorMessage = 'Server error: ${response.statusCode} - ${response.reasonPhrase}';
          });
          _showFailAnimation();
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: ${e.toString()}';
      });
      _showFailAnimation();
      print('Network error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Speech with Avatar'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar Section
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _riveArtboard == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Rive(
                        artboard: _riveArtboard!,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            
            // Status indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isPlaying ? Icons.volume_up : Icons.volume_off,
                  color: _isPlaying ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  _isPlaying ? 'Avatar is speaking...' : 'Avatar is ready',
                  style: TextStyle(
                    color: _isPlaying ? Colors.green : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter text for avatar to speak',
                hintText: 'Type something here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedVoice,
              decoration: InputDecoration(
                labelText: 'Select Voice',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _availableVoices.map((voice) {
                return DropdownMenuItem<String>(
                  value: voice,
                  child: Text(voice.toUpperCase()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedVoice = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _convertTextToSpeech,
              icon: _isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    )
                  : const Icon(Icons.record_voice_over),
              label: Text(_isLoading ? 'Generating...' : 'Make Avatar Speak'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Audio controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filled(
                  icon: const Icon(Icons.replay),
                  onPressed: () async {
                    if (_audioPlayer.audioSource != null) {
                      await _audioPlayer.seek(Duration.zero);
                      await _audioPlayer.play();
                    }
                  },
                  tooltip: 'Replay',
                ),
                IconButton.filled(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () async {
                    if (_isPlaying) {
                      await _audioPlayer.pause();
                    } else if (_audioPlayer.audioSource != null) {
                      await _audioPlayer.play();
                    }
                  },
                  tooltip: _isPlaying ? 'Pause' : 'Play',
                ),
                IconButton.filled(
                  icon: const Icon(Icons.stop),
                  onPressed: () async {
                    await _audioPlayer.stop();
                  },
                  tooltip: 'Stop',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom AudioSource to play from memory
class MyCustomSource extends StreamAudioSource {
  final Uint8List _buffer;
  
  MyCustomSource(this._buffer);
  
  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start = start ?? 0;
    end = end ?? _buffer.length;
    
    return StreamAudioResponse(
      sourceLength: _buffer.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_buffer.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}