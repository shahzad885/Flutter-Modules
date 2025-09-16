import 'package:flutter/material.dart';

class DotTypingAnimation extends StatelessWidget {
  const DotTypingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + i * 100),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          height: 8,
          width: 8,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
