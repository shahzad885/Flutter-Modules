import 'package:flutter/material.dart';
import 'package:sky/NeumorphicUI/neumorphic_card.dart';
import 'package:sky/NeumorphicUI/neumorphic_progress_bar.dart';

class Homescreenneumorphic extends StatefulWidget {
  const Homescreenneumorphic({super.key});

  @override
  State<Homescreenneumorphic> createState() => _HomescreenneumorphicState();
}

class _HomescreenneumorphicState extends State<Homescreenneumorphic> {
  double progressValue = 0.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NeumorphicCard(
              width: double.infinity,
              type: NeumorphicCardType.elevated,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Evening'),
                        Text(
                          'Shahzad Ahmad',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        SizedBox(height: 3),
                        Text('Shahzad@gmail.com',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 170,
                      child: ClipRRect(
                          child: Image.asset(
                        'assets/dr.png',
                        fit: BoxFit.contain,
                      )),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Your Progress',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NeumorphicCard(
                  width: 150,
                  height: 130,
                  type: NeumorphicCardType.elevated,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_3_outlined,
                          size: 40,
                        ),
                        Text(
                          'Patient count',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('3/',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            Text('50',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                NeumorphicCard(
                  width: 150,
                  height: 130,
                  type: NeumorphicCardType.inset,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_3_outlined,
                          size: 40,
                        ),
                        Text(
                          'Patient count',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('3/',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            Text('50',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeumorphicCard(
                type: NeumorphicCardType.inset,
                width: double.infinity,
                child: Center(
                  child: NeumorphicProgressBar(
                    progress: progressValue,
                    width: 250,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
