import 'dart:math';

import 'package:animations/controllers/api_controller.dart';
import 'package:animations/views/api_call.dart';
import 'package:animations/views/stacked_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChainedAnimationsPage extends StatefulWidget {
  const ChainedAnimationsPage({super.key});

  @override
  State<ChainedAnimationsPage> createState() => _ChainedAnimationsPageState();
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class _ChainedAnimationsPageState extends State<ChainedAnimationsPage>
    with TickerProviderStateMixin {
  late AnimationController _rotateCounterClockwiseController;
  late Animation<double> _rotateCounterClockwiseAnimation;

  late AnimationController _flipController;
  late Animation _flipAnimation;

  final control = Get.put(ApiController());

  @override
  void initState() {
    super.initState();

    _rotateCounterClockwiseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _rotateCounterClockwiseAnimation = Tween(begin: 0.0, end: -pi / 2).animate(
        CurvedAnimation(
            parent: _rotateCounterClockwiseController,
            curve: Curves.bounceOut));

    _flipController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _flipAnimation = Tween(begin: 0.0, end: pi).animate(
        CurvedAnimation(parent: _flipController, curve: Curves.bounceOut));

    _rotateCounterClockwiseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation =
            Tween(begin: _flipAnimation.value, end: _flipAnimation.value + pi)
                .animate(CurvedAnimation(
                    parent: _flipController, curve: Curves.bounceOut));

        _flipController
          ..reset()
          ..forward();
      }
    });

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotateCounterClockwiseAnimation = Tween(
                begin: _rotateCounterClockwiseAnimation.value,
                end: _rotateCounterClockwiseAnimation.value + (-pi / 2))
            .animate(CurvedAnimation(
                parent: _rotateCounterClockwiseController,
                curve: Curves.bounceOut));

        _rotateCounterClockwiseController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _rotateCounterClockwiseController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  final double middle = 75.0;
  @override
  Widget build(BuildContext context) {
    _rotateCounterClockwiseController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              AnimatedBuilder(
                  animation: _rotateCounterClockwiseController,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateZ(_rotateCounterClockwiseAnimation.value),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _flipAnimation,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.centerRight,
                                transform: Matrix4.identity()
                                  ..rotateY(_flipAnimation.value),
                                child: ClipPath(
                                  clipper: HalfCircleClipper(CircleSides.left),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    color: Colors.purple,
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedBuilder(
                            animation: _flipAnimation,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.centerLeft,
                                transform: Matrix4.identity()
                                  ..rotateY(_flipAnimation.value),
                                child: ClipPath(
                                  clipper: HalfCircleClipper(CircleSides.right),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    color: Colors.blue,
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.brown),
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Previous Page'),
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                onPressed: () {
                  Get.to(() => const StackedAnimation());
                  control.getAlbum();
                },
                child: const Text('Next Page'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum CircleSides { left, right }

extension ToPath on CircleSides {
  Path toPath(Size size) {
    final path = Path();
    late Offset offset;

    ///defines the direction  of movement for drawing an arc
    late bool isClockwise;

    switch (this) {
      case CircleSides.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        isClockwise = false;
        break;
      case CircleSides.right:
        offset = Offset(0, size.height);
        isClockwise = true;
        break;
    }

    path.arcToPoint(offset,

        /// sets the center position from where to draw an arc
        radius: Radius.elliptical(size.width / 2, size.height / 2),
        clockwise: isClockwise);

    ///close a path after defining the direction and curve
    path.close();

    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSides side;

  HalfCircleClipper(this.side);
  @override
  Path getClip(Size size) => side.toPath(size);

  ///Observes changes happening on the parent widget and tells
  /// the parent if to redraw the child or not
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
