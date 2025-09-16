// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SketchTutorialManager {
//   static const String _tutorialCompletedKey = 'sketch_tutorial_completed';
  
//   // Keys for tutorial targets
//   static final GlobalKey colorPickerKey = GlobalKey();
//   static final GlobalKey strokeWidthKey = GlobalKey();
//   static final GlobalKey clearButtonKey = GlobalKey();
//   static final GlobalKey canvasKey = GlobalKey();
//   static final GlobalKey currentColorKey = GlobalKey();

//   static TutorialCoachMark? _tutorialCoachMark;

//   /// Check if tutorial should be shown (first time user)
//   static Future<bool> shouldShowTutorial() async {
//     final prefs = await SharedPreferences.getInstance();
//     return !(prefs.getBool(_tutorialCompletedKey) ?? false);
//   }

//   /// Mark tutorial as completed
//   static Future<void> markTutorialCompleted() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_tutorialCompletedKey, true);
//   }

//   /// Reset tutorial (for testing or user request)
//   static Future<void> resetTutorial() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_tutorialCompletedKey);
//   }

//   /// Create and show the tutorial
//   static void showTutorial(BuildContext context) {
//     final targets = _createTargets();
    
//     _tutorialCoachMark = TutorialCoachMark(
//       targets: targets,
//       colorShadow: Colors.black54,
//       textSkip: "SKIP",
//       paddingFocus: 10,
//       opacityShadow: 0.8,
//       imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//       onFinish: () {
//         markTutorialCompleted();
//       },
//       onSkip: () {
//         markTutorialCompleted();
//         return true;
//       },
//     );

//     _tutorialCoachMark!.show(context: context);
//   }

//   /// Create tutorial targets with descriptions
//   static List<TargetFocus> _createTargets() {
//     return [
//       // Canvas introduction
//       TargetFocus(
//         identify: "canvas",
//         keyTarget: canvasKey,
//         alignSkip: Alignment.topRight,
//         enableOverlayTab: true,
//         contents: [
//           TargetContent(
//             align: ContentAlign.top,
//             builder: (context, controller) {
//               return _buildContentCard(
//                 title: "Welcome to Sketch Pad! 🎨",
//                 description: "This is your drawing canvas where you can create amazing sketches. Tap anywhere to start drawing!",
//                 controller: controller,
//                 isFirst: true,
//               );
//             },
//           ),
//         ],
//       ),

//       // Color picker
//       TargetFocus(
//         identify: "color_picker",
//         keyTarget: colorPickerKey,
//         alignSkip: Alignment.topRight,
//         enableOverlayTab: true,
//         contents: [
//           TargetContent(
//             align: ContentAlign.bottom,
//             builder: (context, controller) {
//               return _buildContentCard(
//                 title: "Choose Your Colors 🌈",
//                 description: "Tap this button to reveal the color palette. Select from 10 beautiful colors to make your artwork vibrant!",
//                 controller: controller,
//               );
//             },
//           ),
//         ],
//       ),

//       // Current color indicator
//       TargetFocus(
//         identify: "current_color",
//         keyTarget: currentColorKey,
//         alignSkip: Alignment.topRight,
//         enableOverlayTab: true,
//         contents: [
//           TargetContent(
//             align: ContentAlign.bottom,
//             builder: (context, controller) {
//               return _buildContentCard(
//                 title: "Current Color 🎯",
//                 description: "This circle shows your currently selected color. It updates automatically when you pick a new color.",
//                 controller: controller,
//               );
//             },
//           ),
//         ],
//       ),

//       // Stroke width selector
//       TargetFocus(
//         identify: "stroke_width",
//         keyTarget: strokeWidthKey,
//         alignSkip: Alignment.topRight,
//         enableOverlayTab: true,
//         contents: [
//           TargetContent(
//             align: ContentAlign.bottom,
//             builder: (context, controller) {
//               return _buildContentCard(
//                 title: "Brush Size Control 🖌️",
//                 description: "Adjust the thickness of your brush strokes with this slider. Go from fine details to bold strokes!",
//                 controller: controller,
//               );
//             },
//           ),
//         ],
//       ),

//       // Clear button
//       TargetFocus(
//         identify: "clear_button",
//         keyTarget: clearButtonKey,
//         alignSkip: Alignment.topRight,
//         enableOverlayTab: true,
//         contents: [
//           TargetContent(
//             align: ContentAlign.bottom,
//             builder: (context, controller) {
//               return _buildContentCard(
//                 title: "Start Fresh 🗑️",
//                 description: "Made a mistake or want to start over? Tap this clear button to erase everything and begin with a clean canvas.",
//                 controller: controller,
//                 isLast: true,
//               );
//             },
//           ),
//         ],
//       ),
//     ];
//   }

//   /// Build a consistent content card for tutorial steps
//   static Widget _buildContentCard({
//     required String title,
//     required String description,
//     required TutorialCoachMarkController controller,
//     bool isFirst = false,
//     bool isLast = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             spreadRadius: 0,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             description,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.black54,
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if (!isFirst)
//                 TextButton(
//                   onPressed: controller.previous,
//                   child: const Text(
//                     'Previous',
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               if (isFirst) const Spacer(),
//               Row(
//                 children: [
//                   if (!isLast)
//                     TextButton(
//                       onPressed: controller.skip,
//                       child: const Text(
//                         'Skip Tutorial',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: isLast 
//                         ? () {
//                             markTutorialCompleted();
//                             _tutorialCoachMark?.finish();
//                           }
//                         : controller.next,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Text(
//                       isLast ? 'Get Started!' : 'Next',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   /// Dispose tutorial resources
//   static void dispose() {
//     _tutorialCoachMark = null;
//   }
// }

// /// Extension to add tutorial helper methods
// extension SketchTutorialExtension on State {
//   /// Show tutorial with proper delay for widget rendering
//   void showTutorialAfterBuild() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(const Duration(milliseconds: 500), () {
//         if (mounted) {
//           SketchTutorialManager.showTutorial(context);
//         }
//       });
//     });
//   }
// }