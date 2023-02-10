import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Center(
                child: AnimatedBuilder(
                  animation:
                      Listenable.merge([xController, yController, zController]),
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..rotateX(animator.evaluate(xController))
                        ..rotateY(animator.evaluate(yController))
                        ..rotateZ(animator.evaluate(zController)),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Transform(
                            transform: Matrix4.identity()
                              ..translate(Vector3(0, 0, -100)),
                            child: Container(
                              height: 100,
                              width: 100,
                              color: const Color(0xffde03fc),
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            color: const Color(0xfffc0f03),
                          ),
                          Transform(
                            alignment: Alignment.centerLeft,
                            transform: Matrix4.identity()..rotateY((pi / 2)),
                            child: Container(
                              height: 100,
                              width: 100,
                              color: const Color(0xff0bfc03),
                            ),
                          ),
                          Transform(
                            alignment: Alignment.centerRight,
                            transform: Matrix4.identity()..rotateY(-(pi / 2)),
                            child: Container(
                              height: 100,
                              width: 100,
                              color: const Color(0xff031cfc),
                            ),
                          ),
                          Transform(
                            alignment: Alignment.topCenter,
                            transform: Matrix4.identity()..rotateX(-(pi / 2)),
                            child: Container(
                              height: 100,
                              width: 100,
                              color: const Color(0xfffcf803),
                            ),
                          ),
                          Transform(
                            alignment: Alignment.bottomCenter,
                            transform: Matrix4.identity()..rotateX((pi / 2)),
                            child: Container(
                              height: 100,
                              width: 100,
                              color: const Color(0xff03fcd7),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
