import 'package:flutter/material.dart';

class StackedAnimation extends StatefulWidget {
  const StackedAnimation({super.key});

  @override
  State<StackedAnimation> createState() => _StackedAnimationState();
}

class _StackedAnimationState extends State<StackedAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stacked animations page'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(),
        ),
      ),
    );
  }
}
