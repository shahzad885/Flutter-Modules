import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoService {
  // Replace with your actual Zego Cloud credentials
  static const int appID = 123456789; // Your App ID
  static const String appSign = "71a41b2bd70f0a553102890da1a0f1eaf821878b00617b587e7fbd1c443e0562"; // Your App Sign
  
  static bool _initialized = false;

  // Initialize Zego UIKit
  static Future<void> initialize(String userID, String userName) async {
    if (_initialized) return;

    try {
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: userName,
        plugins: [ZegoUIKitSignalingPlugin()],
      );
      
      _initialized = true;
      debugPrint('Zego UIKit initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Zego UIKit: $e');
    }
  }

  // Uninitialize Zego UIKit
  static Future<void> uninitialize() async {
    if (!_initialized) return;

    try {
      await ZegoUIKitPrebuiltCallInvitationService().uninit();
      _initialized = false;
      debugPrint('Zego UIKit uninitialized');
    } catch (e) {
      debugPrint('Error uninitializing Zego UIKit: $e');
    }
  }

  // Send call invitation
  // static Future<bool> sendCallInvitation({
  //   required List<String> invitees,
  //   required bool isVideoCall,
  //   String? customData,
  // }) async {
  //   try {
  //     final result = await ZegoUIKitPrebuiltCallInvitationService()
  //         .sendInvitation(
  //       invitees: invitees.map((e) => ZegoUIKitUser(id: e, name: e)).toList(),
  //       isVideoCall: isVideoCall,
  //       customData: customData,
  //     );
      
  //     return result.error == null;
  //   } catch (e) {
  //     debugPrint('Error sending call invitation: $e');
  //     return false;
  //   }
  // }

  // Create call page
  static Widget buildCallPage({
    required String callID,
    required String userID,
    required String userName,
    required bool isVideoCall,
    VoidCallback? onCallEnd,
  }) {
    return ZegoUIKitPrebuiltCall(
      appID: appID,
      appSign: appSign,
      userID: userID,
      userName: userName,
      callID: callID,
      config: isVideoCall
          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }

  // Get call configuration
  static ZegoUIKitPrebuiltCallConfig getCallConfig(bool isVideoCall) {
    final config = isVideoCall
        ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

    // // Customize the config
    // config.onOnlySelfInRoom = (context) {
    //   Navigator.of(context).pop();
    // };

    // config.onHangUp = () {
    //   debugPrint('Call ended');
    // };

    // Audio/Video settings
    config.turnOnCameraWhenJoining = isVideoCall;
    config.turnOnMicrophoneWhenJoining = true;
    config.useSpeakerWhenJoining = isVideoCall;

    // UI customization
    config.audioVideoViewConfig.showSoundWavesInAudioMode = true;
    config.audioVideoViewConfig.showUserNameOnView = true;
    
    return config;
  }

  // Check if initialized
  static bool get isInitialized => _initialized;
}