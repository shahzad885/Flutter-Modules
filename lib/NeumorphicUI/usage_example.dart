// main.dart - Usage Example
import 'package:flutter/material.dart';
import 'package:sky/Login_neumorphic.dart';
import 'package:sky/NeumorphicUI/homescreenNeumorphic.dart';
// Import all your neumorphic components
import 'pagination_point.dart';
import 'neumorphic_icon.dart';
import 'neumorphic_button.dart';
import 'neumorphic_toggle.dart';
import 'neumorphic_progress_bar.dart';
import 'neumorphic_swipe_button.dart';
import 'neumorphic_input.dart';
import 'neumorphic_card.dart';

class NeumorphicDemo extends StatefulWidget {
  const NeumorphicDemo({super.key});

  @override
  _NeumorphicDemoState createState() => _NeumorphicDemoState();
}

class _NeumorphicDemoState extends State<NeumorphicDemo> {
  int currentPage = 0;
  bool toggleValue = false;
  bool toggle2Value = true;
  double progressValue = 0.6;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // var screenWidth = MediaQuery.of(context).size.width;
    // var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Neumorphic UI Components',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 30),

              // Pagination Points
              const Text('Pagination Points:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              Row(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: NeumorphicPaginationPoint(
                      isActive: index == currentPage,
                      onTap: () => setState(() => currentPage = index),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),

              // Icons
              const Text('Neumorphic Icons:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              Row(
                children: [
                  NeumorphicIcon(
                    icon: Icons.home,
                    onTap: () => print('Home tapped'),
                  ),
                  const SizedBox(width: 15),
                  NeumorphicIcon(
                    icon: Icons.favorite,
                    iconColor: Colors.teal,
                    onTap: () => print('Favorite tapped'),
                  ),
                  const SizedBox(width: 15),
                  NeumorphicIcon(
                    icon: Icons.settings,
                    iconColor: Colors.orange,
                    onTap: () => print('Settings tapped'),
                  ),
                  const SizedBox(width: 15),
                  NeumorphicIcon(
                    icon: Icons.person,
                    onTap: () => print('Profile tapped'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Buttons
              const Text('Neumorphic Buttons:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              Row(
                children: [
                  NeumorphicButton(
                    style: NeumorphicButtonStyle.flat,
                    child: const Text('LoginUI',
                        style: TextStyle(color: Color(0xFF2C3E50))),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginNeumorphic()),
                    ),
                  ),
                  const SizedBox(width: 15),
                  NeumorphicButton(
                    width: 110,
                    style: NeumorphicButtonStyle.curved,
                    child: const Text('homescreen',
                        style: TextStyle(color: Color(0xFF2C3E50))),
 onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Homescreenneumorphic()),
                    ),                    
                  ),
                  const SizedBox(width: 15),
                  NeumorphicButton(
                    style: NeumorphicButtonStyle.soft,
                    child: const Text('Soft',
                        style: TextStyle(color: Color(0xFF2C3E50))),
                    onPressed: () => print('Soft button pressed'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Toggles
              const Text('Neumorphic Toggles:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Column(
                    children: [
                      const Text('Toggle 1', style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 8),
                      NeumorphicToggle(
                        value: toggleValue,
                        onChanged: (value) =>
                            setState(() => toggleValue = value),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    children: [
                      const Text('Toggle 2', style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 8),
                      NeumorphicToggle(
                        value: toggle2Value,
                        onChanged: (value) =>
                            setState(() => toggle2Value = value),
                        activeColor: const Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Progress Bar
              const Text('Progress Bar:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              NeumorphicProgressBar(
                progress: progressValue,
                width: 250,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() =>
                        progressValue = (progressValue - 0.1).clamp(0.0, 1.0)),
                    child: const Text('-'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => setState(() =>
                        progressValue = (progressValue + 0.1).clamp(0.0, 1.0)),
                    child: const Text('+'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Swipe Button
              const Text('Swipe Button:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              NeumorphicSwipeButton(
                width: 250,
                child: const Text(
                  'Swipe to confirm',
                  style: TextStyle(
                    color: Color(0xFF8A96A3),
                    fontSize: 16,
                  ),
                ),
                onSwipeComplete: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Swipe completed!')),
                  );
                },
              ),
              const SizedBox(height: 30),

              // Input Field
              const Text('Input Field:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              NeumorphicInput(
                controller: textController,
                hintText: 'Enter your text...',
                prefixIcon: Icons.search,
                suffixIcon: Icons.clear,
                onSuffixIconTap: () => textController.clear(),
                height: 50,
                width: 300,
              ),
              const SizedBox(height: 30),

              // Cards
              const Text('Neumorphic Cards:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              Row(
                children: [
                  NeumorphicCard(
                    width: 150,
                    height: 120,
                    type: NeumorphicCardType.elevated,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.card_giftcard,
                              size: 32, color: Color(0xFF7B68EE)),
                          SizedBox(height: 8),
                          Text('Elevated Card', style: TextStyle(fontSize: 12)),
                          SizedBox()
                        ],
                      ),
                    ),
                    onTap: () => print('Elevated card tapped'),
                  ),
                  const SizedBox(width: 20),
                  NeumorphicCard(
                    width: 150,
                    height: 120,
                    type: NeumorphicCardType.inset,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card,
                              size: 32, color: Color(0xFF8A96A3)),
                          SizedBox(height: 8),
                          Text('Inset Card', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    onTap: () => print('Inset card tapped'),
                  ),
                ],
              ),
              const SizedBox(height: 50),

             
            ],
          ),
        ),
      ),
    );
  }
}
