// import 'package:flutter/material.dart';
// import 'package:sky/NeumorphicUI/usage_example.dart';


// void main() {
//   runApp(const StoryGeneratorApp());
// }

// class StoryGeneratorApp extends StatelessWidget {
//   const StoryGeneratorApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Story Generator',
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color.fromARGB(255, 244, 244, 241),
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//   home:  NeumorphicDemo(),    );
//   }
// }






// //   ----------------------------------------    main for chatbot

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sky/chatbot/Providers/providers.dart';
import 'package:sky/chatbot/Screens/chat_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables before running the app
  await dotenv.load(fileName: ".env");
  
  runApp(const PsychologyAssistantApp());
}

class PsychologyAssistantApp extends StatelessWidget {

  const PsychologyAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Psychology Assistant',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (context) => ChatProvider(),
        child: const ChatbotHelpScreen(),
      ),
    );
  }
}

//-------------------------- main for Calling ---------------------

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sky/videoCall/call_history_screen.dart';
// import 'package:sky/videoCall/call_provider.dart';
// import 'package:sky/videoCall/contacts_screen.dart';
// import 'package:sky/videoCall/incoming_call_screen.dart';
// import 'package:sky/videoCall/zego_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Initialize Firebase
//   await Firebase.initializeApp();
  
//   // Request permissions
//   await _requestPermissions();
  
//   runApp(const MyApp());
// }

// Future<void> _requestPermissions() async {
//   await [
//     Permission.camera,
//     Permission.microphone,
//     Permission.notification,
//   ].request();
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => CallProvider()),
//       ],
//       child: MaterialApp(
//         title: 'Video Call App',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: const AuthWrapper(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
        
//         if (snapshot.hasData && snapshot.data != null) {
//           return const MainScreen();
//         }
        
//         return const LoginScreen();
//       },
//     );
//   }
// }

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _nameController = TextEditingController();
//   bool _isLogin = true;
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isLogin ? 'Login' : 'Sign Up'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (!_isLogin)
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Full Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             if (!_isLogin) const SizedBox(height: 16),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _handleAuth,
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : Text(_isLogin ? 'Login' : 'Sign Up'),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _isLogin = !_isLogin;
//                 });
//               },
//               child: Text(
//                 _isLogin
//                     ? 'Don\'t have an account? Sign Up'
//                     : 'Already have an account? Login',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _handleAuth() async {
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//       return;
//     }

//     if (!_isLogin && _nameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter your name')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       if (_isLogin) {
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text,
//         );
//       } else {
//         final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text,
//         );
        
//         // Update user profile
//         await credential.user?.updateDisplayName(_nameController.text.trim());
        
//         // Save user data to Firestore
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(credential.user!.uid)
//             .set({
//           'uid': credential.user!.uid,
//           'email': _emailController.text.trim(),
//           'displayName': _nameController.text.trim(),
//           'isOnline': true,
//           'createdAt': Timestamp.now(),
//         });
//       }
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message ?? 'Authentication failed')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _nameController.dispose();
//     super.dispose();
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
  
//   final List<Widget> _screens = [
//     const ContactsScreen(),
//     const CallHistoryScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeServices();
//   }

//   Future<void> _initializeServices() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       // Initialize Zego UIKit
//       await ZegoService.initialize(user.uid, user.displayName ?? 'User');
      
//       // Initialize call provider
//       final callProvider = context.read<CallProvider>();
//       callProvider.initializeCallListener();
//       callProvider.loadCallHistory();
      
//       // Update user online status
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .update({'isOnline': true});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           IndexedStack(
//             index: _currentIndex,
//             children: _screens,
//           ),
//           // Incoming call overlay
//           Consumer<CallProvider>(
//             builder: (context, callProvider, child) {
//               if (callProvider.callStatus == CallStatus.receiving) {
//                 return const IncomingCallScreen();
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Contacts',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: 'History',
//           ),
//         ],
//       ),
//       appBar: AppBar(
//         title: Text(_currentIndex == 0 ? 'Contacts' : 'Call History'),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'logout') {
//                 _handleLogout();
//               }
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'logout',
//                 child: Row(
//                   children: [
//                     Icon(Icons.logout),
//                     SizedBox(width: 8),
//                     Text('Logout'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _handleLogout() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Update user offline status
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .update({'isOnline': false});
//       }
      
//       // Uninitialize Zego
//       await ZegoService.uninitialize();
      
//       // Sign out
//       await FirebaseAuth.instance.signOut();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error signing out: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     // Update offline status when app is closed
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .update({'isOnline': false});
//     }
//     super.dispose();
//   }
// }