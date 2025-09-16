import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'zego_service.dart';
import 'call_provider.dart';

class CallScreen extends StatefulWidget {
  final String callId;
  final bool isVideoCall;

  const CallScreen({
    super.key,
    required this.callId,
    required this.isVideoCall,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CallProvider>().acceptCall();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CallProvider>(
      builder: (context, callProvider, child) {
        return Scaffold(
          body: ZegoService.buildCallPage(
            callID: widget.callId,
            userID: callProvider.currentUserId,
            userName: callProvider.currentUserName,
            isVideoCall: widget.isVideoCall,
            onCallEnd: () {
              callProvider.endCall();
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}