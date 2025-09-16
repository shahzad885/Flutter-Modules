import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  const VideoCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZEGO Prebuilt Call',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _callIDController = TextEditingController(text: 'test_call_id');
  late final TextEditingController _userIDController;
  late final TextEditingController _userNameController;

  final int appID = 1851421192;
  final String appSign = '71a41b2bd70f0a553102890da1a0f1eaf821878b00617b587e7fbd1c443e0562';

  @override
  void initState() {
    super.initState();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    _userIDController = TextEditingController(text: 'user_$timestamp');
    _userNameController = TextEditingController(text: 'User_$timestamp');

    requestPermissions();
  }

 Future<void> requestPermissions() async {
  final statuses = await [Permission.camera, Permission.microphone].request();
  if (statuses.values.any((status) => !status.isGranted)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please grant camera and microphone permissions')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZEGO Prebuilt Call')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _callIDController,
              decoration: const InputDecoration(labelText: 'Call ID'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _userIDController,
              decoration: const InputDecoration(labelText: 'Your User ID'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'Your User Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => startCall(context),
              child: const Text('Start / Join Video Call'),
            ),
          ],
        ),
      ),
    );
  }

  void startCall(BuildContext context) {
    if (_callIDController.text.isEmpty || _userIDController.text.isEmpty || _userNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallPage(
          appID: appID,
          appSign: appSign,
          callID: _callIDController.text,
          userID: _userIDController.text,
          userName: _userNameController.text,
        ),
      ),
    );
  }
}

class CallPage extends StatelessWidget {
  final int appID;
  final String appSign;
  final String callID;
  final String userID;
  final String userName;

  const CallPage({
    super.key,
    required this.appID,
    required this.appSign,
    required this.callID,
    required this.userID,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: appID,
      appSign: appSign,
      userID: userID,
      userName: userName,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
}
