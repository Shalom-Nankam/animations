import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

import '../models/particles.dart';
import '../models/spring.dart';

class SpringAnimation2 extends StatefulWidget {
  const SpringAnimation2({super.key});

  @override
  State<SpringAnimation2> createState() => _SpringAnimation2State();
}

class _SpringAnimation2State extends State<SpringAnimation2> {
  late v.Vector2 gravity;
  late Timer timer;
  double lengthAtRest = 300;
  double k = 0.01;

  late List<Particle> _particles;
  late List<Spring> _springs;
  late int noOfParticles;

  @override
  void initState() {
    noOfParticles = 10;
    _particles = List<Particle>.filled(noOfParticles, Particle(0, 0));
    _springs = List<Spring>.filled(
        noOfParticles, Spring(_particles[0], _particles[1], 0, 0));
    gravity = v.Vector2(0, 0.1);

    for (int i = 0; i < noOfParticles; i++) {
      // _particles[i] = Particle(60 + i * spacing, 50 + i * spacing);

      if (i != 0) {
        var a = _particles[0];
        var b = _particles[i - 1];
        var spring = Spring(a, b, k, lengthAtRest);

        _springs[i] = spring;
      }
    }
    _particles.first.fixed = true;
    _particles.last.fixed = true;
    update();
    super.initState();
  }

  void update() {
    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      for (var spring in _springs) {
        spring.update();
      }

      for (var particle in _particles) {
        particle.applyForce(gravity);
        particle.update();
      }
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
              painter: SpringPainter(_particles),
              // child: Container(),
            ),
          ),
        ));
  }
}

class SpringPainter extends CustomPainter {
  late final List<Particle> _particles;

  SpringPainter(
    this._particles,
  );

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

    // canvas.drawCircle(Offset(anchor.x, anchor.y), 20, anchorPaint);
    // canvas.drawCircle(Offset(child.x, child.y), 40, childPaint);
    // canvas.drawLine(
    //     Offset(anchor.x, anchor.y), Offset(child.x, child.y), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
