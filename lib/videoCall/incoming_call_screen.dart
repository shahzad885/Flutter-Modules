import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'call_provider.dart';
import 'call_screen.dart';

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CallProvider>(
      builder: (context, callProvider, child) {
        final call = callProvider.currentCall;
        
        if (call == null || callProvider.callStatus != CallStatus.receiving) {
          return const SizedBox.shrink();
        }

        return Scaffold(
          backgroundColor: Colors.black87,
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                
                // Caller Info
                Column(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      call.callerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      call.type == CallType.video ? 'Video Call' : 'Voice Call',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Call Actions
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Reject Button
                      GestureDetector(
                        onTap: () {
                          callProvider.rejectCall();
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      
                      // Accept Button
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => CallScreen(
                                callId: call.callId,
                                isVideoCall: call.type == CallType.video,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}