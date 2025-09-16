// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SkymuseRecordingScreen extends StatefulWidget {
  const SkymuseRecordingScreen({super.key});

  @override
  _SkymuseRecordingScreenState createState() => _SkymuseRecordingScreenState();
}

class _SkymuseRecordingScreenState extends State<SkymuseRecordingScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  bool isRecording = false;
  bool isPaused = false;
  int seconds = 0;
  int minutes = 0;
  Timer? _timer;
  FlutterSoundRecorder? _recorder;
  final List<double> _audioLevels = [];
  static const int MAX_MINUTES = 3;
  String? _audioPath;
  bool _isRecorderInitialized = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    initializeRecorder();
  }

  Future<void> initializeRecorder() async {
    try {
      await _requestPermissions();
      await _recorder!.openRecorder();
      setState(() {
        _isRecorderInitialized = true;
      });
    } catch (e) {
      print('Error initializing recorder: $e');
      _showErrorDialog('Failed to initialize recorder: $e');
    }
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds < 59) {
          seconds++;
        } else {
          seconds = 0;
          minutes++;
        }
        if (minutes >= MAX_MINUTES) {
          stopRecording();
        }
      });
    });
  }

  Future<String> _getAudioPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.aac';
  }

  Future<void> startRecording() async {
    if (!_isRecorderInitialized) {
      _showErrorDialog('Recorder not initialized');
      return;
    }

    try {
      _audioPath = await _getAudioPath();
      
      await _recorder!.startRecorder(
        toFile: _audioPath,
        codec: Codec.aacADTS,
      );
      
      startTimer();
      
      setState(() {
        isRecording = true;
        isPaused = false;
      });
      
      _waveController.repeat();
      
      // Simulate audio levels (since flutter_sound doesn't provide real-time amplitude)
      _startAudioLevelSimulation();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording started successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      
    } catch (e) {
      print('Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startAudioLevelSimulation() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!isRecording || isPaused) {
        timer.cancel();
        return;
      }
      
      setState(() {
        // Simulate audio levels with random values
        _audioLevels.add((math.Random().nextDouble() * 0.8 + 0.2));
        if (_audioLevels.length > 30) {
          _audioLevels.removeAt(0);
        }
      });
    });
  }

  Future<void> pauseRecording() async {
    if (!isRecording || !_isRecorderInitialized) return;
    
    try {
      if (isPaused) {
        await _recorder!.resumeRecorder();
        startTimer();
        _waveController.repeat();
        _startAudioLevelSimulation();
      } else {
        await _recorder!.pauseRecorder();
        _timer?.cancel();
        _waveController.stop();
      }
      setState(() {
        isPaused = !isPaused;
      });
    } catch (e) {
      print('Error pausing/resuming recording: $e');
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecorderInitialized) return;
    
    try {
      _timer?.cancel();
      
      await _recorder!.stopRecorder();
      _waveController.stop();
      
      setState(() {
        isRecording = false;
        isPaused = false;
        seconds = 0;
        minutes = 0;
        _audioLevels.clear();
      });
      
      if (_audioPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Recording saved to: ${_audioPath!.split('/').last}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _timer?.cancel();
    if (_isRecorderInitialized) {
      _recorder!.closeRecorder();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              painter: StarsPainter(),
              size: Size.infinite,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Capture Your Response',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5F5DC),
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'What motivates you to pursue your dreams?',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFB0B0B0),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Expanded(child: SizedBox()),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background numbers
                        Positioned(
                          top: 50,
                          right: MediaQuery.of(context).size.width * 0.4,
                          child: Text('1', style: _numberStyle()),
                        ),
                        Positioned(
                          top: 80,
                          right: MediaQuery.of(context).size.width * 0.2,
                          child: Text('2', style: _numberStyle()),
                        ),
                        Positioned(
                          top: 120,
                          left: MediaQuery.of(context).size.width * 0.2,
                          child: Text('5', style: _numberStyle()),
                        ),
                        Positioned(
                          bottom: 120,
                          left: MediaQuery.of(context).size.width * 0.15,
                          child: Text('6', style: _numberStyle()),
                        ),
                        Positioned(
                          bottom: 80,
                          left: MediaQuery.of(context).size.width * 0.3,
                          child: Text('7', style: _numberStyle()),
                        ),
                        Positioned(
                          bottom: 50,
                          right: MediaQuery.of(context).size.width * 0.25,
                          child: Text('8', style: _numberStyle()),
                        ),
                        SizedBox(
                          width: 200,
                          height: 80,
                          child: CustomPaint(
                            painter: AudioWavePainter(
                              _waveController,
                              _audioLevels,
                              isRecording && !isPaused,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 100,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/screen2pic.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 1,
                          right: 20,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/screen6moon.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFF5F5DC),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Start Recording button when not recording
                  if (!isRecording) ...[
                    SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isRecorderInitialized ? startRecording : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRecorderInitialized 
                              ? const Color(0xFF00BFFF).withOpacity(0.8)
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          _isRecorderInitialized ? 'Start Recording' : 'Initializing...',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Control buttons when recording
                  if (isRecording) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          isPaused ? 'Resume' : 'Pause',
                          () => pauseRecording(),
                        ),
                        _buildControlButton('Stop', () => stopRecording()),
                        _buildControlButton('Restart', () {
                          stopRecording().then((_) => startRecording());
                        }),
                      ],
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _numberStyle() {
    return const TextStyle(
      fontSize: 24,
      color: Color(0xFF2A2A3A),
      fontWeight: FontWeight.w300,
    );
  }

  Widget _buildControlButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 100,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFFF5F5DC),
          side: const BorderSide(color: Color(0xFF2A2A3A), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class StarsPainter extends CustomPainter {
  StarsPainter() : super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final stars = [
      Offset(size.width * 0.85, size.height * 0.25),
      Offset(size.width * 0.9, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.35),
      Offset(size.width * 0.75, size.height * 0.28),
    ];

    for (int i = 0; i < stars.length; i++) {
      final star = stars[i];
      final opacity = (math.sin(1 * 2 * math.pi + i) + 1) / 2;
      paint.color = Colors.white.withOpacity(opacity * 0.8);
      _drawStar(canvas, star, 8, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const double angle = math.pi / 2;
    
    for (int i = 0; i < 4; i++) {
      final x1 = center.dx + size * math.cos(i * angle);
      final y1 = center.dy + size * math.sin(i * angle);
      final x2 = center.dx + (size * 0.4) * math.cos(i * angle + angle / 2);
      final y2 = center.dy + (size * 0.4) * math.sin(i * angle + angle / 2);
      
      if (i == 0) {
        path.moveTo(x1, y1);
      } else {
        path.lineTo(x1, y1);
      }
      path.lineTo(x2, y2);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AudioWavePainter extends CustomPainter {
  final Animation<double> animation;
  final List<double> audioLevels;
  final bool isRecording;

  AudioWavePainter(this.animation, this.audioLevels, this.isRecording) 
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00BFFF)
      ..style = PaintingStyle.fill;

    const barWidth = 4.0;
    const barSpacing = 2.0;
    final totalBars = (size.width / (barWidth + barSpacing)).floor();
    final centerY = size.height / 2;

    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + barSpacing);
      double barHeight;
      
      if (isRecording && audioLevels.isNotEmpty) {
        final levelIndex = (i % audioLevels.length);
        barHeight = audioLevels[levelIndex] * size.height;
      } else {
        final normalizedX = i / totalBars;
        barHeight = math.sin(normalizedX * 4 * math.pi + animation.value * 4 * math.pi) * 
                   (size.height * 0.3) + (size.height * 0.1);
      }

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, centerY - barHeight / 2, barWidth, barHeight),
        const Radius.circular(barWidth / 2),
      );
      
      paint.color = const Color(0xFF00BFFF).withOpacity(0.6 + (barHeight / size.height) * 0.4);
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}