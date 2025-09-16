import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

enum CallStatus { idle, calling, receiving, inCall, ended }
enum CallType { audio, video }

class CallModel {
  final String callId;
  final String callerId;
  final String callerName;
  final String receiverId;
  final String receiverName;
  final CallType type;
  final DateTime timestamp;
  final CallStatus status;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.receiverId,
    required this.receiverName,
    required this.type,
    required this.timestamp,
    required this.status,
  });

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callId: map['callId'] ?? '',
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      type: CallType.values[map['type'] ?? 0],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      status: CallStatus.values[map['status'] ?? 0],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'type': type.index,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status.index,
    };
  }

  CallModel copyWith({
    String? callId,
    String? callerId,
    String? callerName,
    String? receiverId,
    String? receiverName,
    CallType? type,
    DateTime? timestamp,
    CallStatus? status,
  }) {
    return CallModel(
      callId: callId ?? this.callId,
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

class CallProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = const Uuid();

  CallModel? _currentCall;
  CallStatus _callStatus = CallStatus.idle;
  bool _isAudioEnabled = true;
  bool _isVideoEnabled = true;
  List<CallModel> _callHistory = [];

  // Getters
  CallModel? get currentCall => _currentCall;
  CallStatus get callStatus => _callStatus;
  bool get isAudioEnabled => _isAudioEnabled;
  bool get isVideoEnabled => _isVideoEnabled;
  List<CallModel> get callHistory => _callHistory;
  String get currentUserId => _auth.currentUser?.uid ?? '';
  String get currentUserName => _auth.currentUser?.displayName ?? 'Unknown';

  // Initialize call listener
  void initializeCallListener() {
    if (_auth.currentUser == null) return;

    _firestore
        .collection('calls')
        .where('receiverId', isEqualTo: _auth.currentUser!.uid)
        .where('status', isEqualTo: CallStatus.calling.index)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final call = CallModel.fromMap(change.doc.data()!);
          _handleIncomingCall(call);
        }
      }
    });
  }

  // Handle incoming call
  void _handleIncomingCall(CallModel call) {
    _currentCall = call;
    _callStatus = CallStatus.receiving;
    notifyListeners();
  }

  // Initiate call
  Future<String?> initiateCall({
    required String receiverId,
    required String receiverName,
    required CallType type,
  }) async {
    try {
      final callId = _uuid.v4();
      final call = CallModel(
        callId: callId,
        callerId: currentUserId,
        callerName: currentUserName,
        receiverId: receiverId,
        receiverName: receiverName,
        type: type,
        timestamp: DateTime.now(),
        status: CallStatus.calling,
      );

      await _firestore.collection('calls').doc(callId).set(call.toMap());
      
      _currentCall = call;
      _callStatus = CallStatus.calling;
      notifyListeners();

      return callId;
    } catch (e) {
      debugPrint('Error initiating call: $e');
      return null;
    }
  }

  // Accept call
  Future<void> acceptCall() async {
    if (_currentCall == null) return;

    try {
      await _firestore
          .collection('calls')
          .doc(_currentCall!.callId)
          .update({'status': CallStatus.inCall.index});

      _currentCall = _currentCall!.copyWith(status: CallStatus.inCall);
      _callStatus = CallStatus.inCall;
      notifyListeners();
    } catch (e) {
      debugPrint('Error accepting call: $e');
    }
  }

  // Reject call
  Future<void> rejectCall() async {
    if (_currentCall == null) return;

    try {
      await _firestore
          .collection('calls')
          .doc(_currentCall!.callId)
          .update({'status': CallStatus.ended.index});

      _addToCallHistory(_currentCall!.copyWith(status: CallStatus.ended));
      _resetCallState();
    } catch (e) {
      debugPrint('Error rejecting call: $e');
    }
  }

  // End call
  Future<void> endCall() async {
    if (_currentCall == null) return;

    try {
      await _firestore
          .collection('calls')
          .doc(_currentCall!.callId)
          .update({'status': CallStatus.ended.index});

      _addToCallHistory(_currentCall!.copyWith(status: CallStatus.ended));
      _resetCallState();
    } catch (e) {
      debugPrint('Error ending call: $e');
    }
  }

  // Toggle audio
  void toggleAudio() {
    _isAudioEnabled = !_isAudioEnabled;
    notifyListeners();
  }

  // Toggle video
  void toggleVideo() {
    _isVideoEnabled = !_isVideoEnabled;
    notifyListeners();
  }

  // Add to call history
  void _addToCallHistory(CallModel call) {
    _callHistory.insert(0, call);
    if (_callHistory.length > 50) {
      _callHistory = _callHistory.take(50).toList();
    }
  }

  // Reset call state
  void _resetCallState() {
    _currentCall = null;
    _callStatus = CallStatus.idle;
    _isAudioEnabled = true;
    _isVideoEnabled = true;
    notifyListeners();
  }

  // Load call history
  Future<void> loadCallHistory() async {
    try {
      final querySnapshot = await _firestore
          .collection('calls')
          .where('status', isEqualTo: CallStatus.ended.index)
          .where('callerId', isEqualTo: currentUserId)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      final receiverCalls = await _firestore
          .collection('calls')
          .where('status', isEqualTo: CallStatus.ended.index)
          .where('receiverId', isEqualTo: currentUserId)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      _callHistory = [
        ...querySnapshot.docs.map((doc) => CallModel.fromMap(doc.data())),
        ...receiverCalls.docs.map((doc) => CallModel.fromMap(doc.data())),
      ];

      // Sort by timestamp
      _callHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _callHistory = _callHistory.take(50).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading call history: $e');
    }
  }

  // Clear call history
  void clearCallHistory() {
    _callHistory.clear();
    notifyListeners();
  }
}