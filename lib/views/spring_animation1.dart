import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class SpringAnimation extends StatefulWidget {
  const SpringAnimation({super.key});

  @override
  State<SpringAnimation> createState() => _SpringAnimationState();
}

class _SpringAnimationState extends State<SpringAnimation> {
  late v.Vector2 anchor;
  late v.Vector2 child;
  late v.Vector2 velocity;
  late v.Vector2 gravity;
  late Timer timer;
  double lengthAtRest = 300;

  @override
  void initState() {
    anchor = v.Vector2(200, 20);
    child = v.Vector2(200, 100);
    velocity = v.Vector2(0, 0);
    gravity = v.Vector2(0, 0.1);
    update();
    super.initState();
  }

  void update() {
    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      double k = 0.01;

      var forceApplied = child - anchor;
      var x = forceApplied.length - lengthAtRest;
      forceApplied.normalize();
      forceApplied.scale(-1 * k * x);

      velocity.add(forceApplied);
      child.add(velocity);
      velocity.scale(0.99);
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Spring animations page'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: CustomPaint(
              painter: SpringPainter(anchor, child),
              // child: Container(),
            ),
          ),
        ));
  }
}

class SpringPainter extends CustomPainter {
  final v.Vector2 anchor;
  final v.Vector2 child;

  SpringPainter(this.anchor, this.child);

  @override
  void paint(Canvas canvas, Size size) {
    Paint anchorPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    Paint childPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    Paint linePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(anchor.x, anchor.y), 20, anchorPaint);
    canvas.drawCircle(Offset(child.x, child.y), 40, childPaint);
    canvas.drawLine(
        Offset(anchor.x, anchor.y), Offset(child.x, child.y), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
