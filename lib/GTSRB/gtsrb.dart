import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Get available cameras
  final cameras = await availableCameras();
  
  runApp(TrafficSignApp(cameras: cameras));
}

class TrafficSignApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  
  const TrafficSignApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Sign Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: TrafficSignHomePage(cameras: cameras),
    );
  }
}

class TrafficSignHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  
  const TrafficSignHomePage({super.key, required this.cameras});

  @override
  State<TrafficSignHomePage> createState() => _TrafficSignHomePageState();
}

class _TrafficSignHomePageState extends State<TrafficSignHomePage> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isLoading = false;
  File? _capturedImage;
  Map<String, dynamic>? _prediction;
  
  // Update this URL to match your FastAPI server
  final String apiUrl = "http://192.168.100.25:8000"; // Change this IP!
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty) return;
    
    _controller = CameraController(
      widget.cameras[0], // Use the first camera
      ResolutionPreset.medium,
    );
    
    try {
      await _controller!.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;
    
    setState(() {
      _isLoading = true;
      _prediction = null;
    });
    
    try {
      final XFile picture = await _controller!.takePicture();
      setState(() {
        _capturedImage = File(picture.path);
      });
      
      // Send image to API
      await _sendImageToAPI(File(picture.path));
      
    } catch (e) {
      print('Error taking picture: $e');
      _showErrorDialog('Error taking picture: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() {
      _isLoading = true;
      _prediction = null;
    });
    
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
        });
        
        await _sendImageToAPI(File(image.path));
      }
    } catch (e) {
      print('Error picking image: $e');
      _showErrorDialog('Error picking image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // New method to clear current image and return to camera view
  void _recapture() {
    setState(() {
      _capturedImage = null;
      _prediction = null;
    });
  }

  Future<void> _sendImageToAPI(File imageFile) async {
    try {
      // Convert image to base64
      Uint8List imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      
      // Prepare request
      final response = await http.post(
        Uri.parse('$apiUrl/predict-base64'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image': base64Image,
        }),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        setState(() {
          _prediction = result;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
      
    } catch (e) {
      print('API Error: $e');
      _showErrorDialog('Failed to connect to server. Make sure your API is running!\n\nError: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Sign Recognition'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Camera Preview or Image Display
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildImageWidget(),
            ),
          ),
          
          // Prediction Results
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildPredictionWidget(),
            ),
          ),
          
          // Control Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildControlButtons(),
          ),
          
          // Loading indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    if (_capturedImage == null) {
      // Show initial capture buttons
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _takePicture,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take Photo'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _pickFromGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text('From Gallery'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      );
    } else {
      // Show recapture and gallery options when image is captured
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _recapture,
                icon: const Icon(Icons.refresh),
                label: const Text('Take Another'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _pickFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('From Gallery'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Optional: Add a button to analyze the same image again
          if (_prediction != null)
            TextButton.icon(
              onPressed: _isLoading ? null : () => _sendImageToAPI(_capturedImage!),
              icon: const Icon(Icons.analytics, size: 16),
              label: const Text('Analyze Again'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[700],
              ),
            ),
        ],
      );
    }
  }

  Widget _buildImageWidget() {
    if (_capturedImage != null) {
      // Show captured image
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          _capturedImage!,
          fit: BoxFit.cover,
        ),
      );
    } else if (_isInitialized && _controller != null) {
      // Show camera preview
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CameraPreview(_controller!),
      );
    } else {
      // Show placeholder
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Camera Preview\nTap button to take photo',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPredictionWidget() {
    if (_prediction == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.traffic, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Take a photo of a traffic sign\nto get prediction results',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final prediction = _prediction!['prediction'];
    final top3 = _prediction!['top_3_predictions'] as List;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main prediction
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎯 Prediction:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  prediction['class_name'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Confidence: ${(prediction['confidence'] * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Top 3 predictions
          const Text(
            '📊 Top 3 Predictions:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          
          ...top3.map((pred) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      '${top3.indexOf(pred) + 1}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pred['class_name'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${(pred['confidence'] * 100).toStringAsFixed(1)}%',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}