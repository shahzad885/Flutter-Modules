import 'package:flutter/material.dart';
import 'package:sky/NeumorphicUI/neumorphic_button.dart';
import 'package:sky/NeumorphicUI/neumorphic_input.dart';

class LoginNeumorphic extends StatefulWidget {
  const LoginNeumorphic({super.key});

  @override
  State<LoginNeumorphic> createState() => _LoginNeumorphicState();
}

class _LoginNeumorphicState extends State<LoginNeumorphic> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            NeumorphicInput(
              hintText: 'Enter email here...',
              prefixIcon: Icons.email,
              width: 350,
            ),
            SizedBox(height: 15),
            NeumorphicInput(
              hintText: 'Enter password here...',
              prefixIcon: Icons.lock,
              suffixIcon: Icons.visibility,
              width: 350,
            ),
            SizedBox(height: 40),
            NeumorphicButton(
                style: NeumorphicButtonStyle.curved,
                width: 300,
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login, color: Color.fromARGB(137, 44, 62, 80)),
                    SizedBox(width: 10),
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromARGB(137, 44, 62, 80),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 20),
            //line divider
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color.fromARGB(45, 44, 62, 80),
                      thickness: 1,
                      // indent: 50,
                      //  endIndent: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('or ', style: TextStyle(color: Color(0xFF2C3E50))),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      color: Color.fromARGB(45, 44, 62, 80),
                      thickness: 1,
                      // indent: 50,
                      // endIndent: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NeumorphicButton(style: NeumorphicButtonStyle.flat,
                    width: 80,
                    height: 45, child: Text('Google', style: TextStyle(color: Color(0xFF2C3E50)))),
                SizedBox(width: 10),
                NeumorphicButton(style: NeumorphicButtonStyle.flat,
                    width: 80,
                    height: 45, child: Text('phone', style: TextStyle(color: Color(0xFF2C3E50)))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
