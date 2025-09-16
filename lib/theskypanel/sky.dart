// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:shimmer/shimmer.dart'; // Add this import

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'The sky panel',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: _SkyState(),
//     );
//   }
// }

// class _SkyState extends StatefulWidget {
//   @override
//   __SkyStateState createState() => __SkyStateState();
// }

// class __SkyStateState extends State<_SkyState> {
//   late WebViewController controller;
//   bool isLoading = true;
//   bool canGoBack = false;

//   @override
//   void initState() {
//     super.initState();
    
//     // Initialize the controller with a single navigation delegate
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             setState(() {
//               isLoading = true;
//             });
//             print("Page started loading: $url");
//           },
//           onPageFinished: (String url) async {
//             print("Page finished loading: $url");
//             // Use Future.delayed to ensure the page is fully loaded
//             Future.delayed(Duration(milliseconds: 300), () {
//               setState(() {
//                 isLoading = false;
//               });
//             });
            
//             // Check if we can go back
//             canGoBack = await controller.canGoBack();
//             setState(() {});
//           },
//           onUrlChange: (UrlChange change) async {
//             print("URL changed: ${change.url}");
//             canGoBack = await controller.canGoBack();
//             setState(() {});
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             // You can intercept navigation here if needed
//             return NavigationDecision.navigate;
//           },
//           onWebResourceError: (WebResourceError error) {
//             print("Error: ${error.description}");
//             setState(() {
//               isLoading = false;
//             });
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://theskypanel.com'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (await controller.canGoBack()) {
//           controller.goBack();
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 1,
//         ),
        
//         body: Stack(
//           children: [
//             WebViewWidget(controller: controller),
//             if (isLoading)
//               Container(
//                 color: Colors.white,
//                 child: _buildShimmerEffect(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
  
//   // Shimmer effect widget
//   Widget _buildShimmerEffect() {
//     return Shimmer.fromColors(
//       baseColor: const Color.fromARGB(114, 224, 224, 224)!,
//       highlightColor: const Color.fromARGB(68, 245, 245, 245)!,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header area
//             Container(
//               height: 60,
//               margin: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
            
//             // Content placeholder
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: 10,
//               itemBuilder: (_, __) => Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: double.infinity,
//                             height: 16,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Container(
//                             width: double.infinity,
//                             height: 16,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Container(
//                             width: 100,
//                             height: 16,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }