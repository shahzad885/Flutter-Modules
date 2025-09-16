import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky/videoCall/call_screen.dart';
import 'call_provider.dart';

class CallHistoryScreen extends StatelessWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call History'),
        actions: [
          Consumer<CallProvider>(
            builder: (context, callProvider, child) {
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () {
                  _showClearHistoryDialog(context, callProvider);
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CallProvider>(
        builder: (context, callProvider, child) {
          if (callProvider.callHistory.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.call,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No call history',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: callProvider.callHistory.length,
            itemBuilder: (context, index) {
              final call = callProvider.callHistory[index];
              final isOutgoing = call.callerId == callProvider.currentUserId;
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: call.type == CallType.video
                        ? Colors.blue[100]
                        : Colors.green[100],
                    child: Icon(
                      call.type == CallType.video
                          ? Icons.videocam
                          : Icons.call,
                      color: call.type == CallType.video
                          ? Colors.blue
                          : Colors.green,
                    ),
                  ),
                  title: Text(
                    isOutgoing ? call.receiverName : call.callerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isOutgoing ? Icons.call_made : Icons.call_received,
                            size: 16,
                            color: isOutgoing ? Colors.green : Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isOutgoing ? 'Outgoing' : 'Incoming',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDateTime(call.timestamp),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          call.type == CallType.video
                              ? Icons.videocam
                              : Icons.call,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          _initiateCall(
                            context,
                            callProvider,
                            isOutgoing ? call.receiverId : call.callerId,
                            isOutgoing ? call.receiverName : call.callerName,
                            call.type,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () {
                          _showCallDetails(context, call, isOutgoing);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _initiateCall(
    BuildContext context,
    CallProvider callProvider,
    String receiverId,
    String receiverName,
    CallType type,
  ) async {
    final callId = await callProvider.initiateCall(
      receiverId: receiverId,
      receiverName: receiverName,
      type: type,
    );

    if (callId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CallScreen(
            callId: callId,
            isVideoCall: type == CallType.video,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to initiate call'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCallDetails(BuildContext context, CallModel call, bool isOutgoing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type', call.type == CallType.video ? 'Video Call' : 'Voice Call'),
            _buildDetailRow('Direction', isOutgoing ? 'Outgoing' : 'Incoming'),
            _buildDetailRow('Contact', isOutgoing ? call.receiverName : call.callerName),
            _buildDetailRow('Date & Time', _formatDateTime(call.timestamp)),
            _buildDetailRow('Call ID', call.callId),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, CallProvider callProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Call History'),
        content: const Text('Are you sure you want to clear all call history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              callProvider.clearCallHistory();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final callDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (callDate == today) {
      dateStr = 'Today';
    } else if (callDate == yesterday) {
      dateStr = 'Yesterday';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr $timeStr';
  }
}