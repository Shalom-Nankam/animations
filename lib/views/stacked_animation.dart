import 'dart:math';

import 'package:flutter/material.dart';

class StackedAnimation extends StatefulWidget {
  const StackedAnimation({super.key});

  @override
  State<StackedAnimation> createState() => _StackedAnimationState();
}

class _StackedAnimationState extends State<StackedAnimation>
    with TickerProviderStateMixin {
  late AnimationController xController;
  late AnimationController yController;
  late AnimationController zController;

  late Tween<double> animator;

  @override
  void initState() {
    super.initState();
    xController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));

    yController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));

    zController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));

    animator = Tween(begin: 0, end: pi * 2);
  }

  @override
  void dispose() {
    zController.dispose();
    yController.dispose();
    xController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    xController
      ..reset()
      ..forward();

    yController
      ..reset()
      ..forward();

    zController
      ..reset()
      ..forward();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stacked animations page'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              AnimatedBuilder(
                animation:
                    Listenable.merge([xController, yController, zController]),
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity(),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          color: Colors.red,
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
