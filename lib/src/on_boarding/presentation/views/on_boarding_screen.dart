import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('initial page'),
        ],
      ),
    );
  }
}
