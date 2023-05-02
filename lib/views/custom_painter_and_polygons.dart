import 'dart:math';

import 'package:flutter/material.dart';

class CustomPainterPolygons extends StatefulWidget {
  const CustomPainterPolygons({super.key});

  @override
  State<CustomPainterPolygons> createState() => _CustomPainterPolygonsState();
}

class _CustomPainterPolygonsState extends State<CustomPainterPolygons>
    with TickerProviderStateMixin {
  late AnimationController _sidesController;
  late Animation<int> _sidesAnimation;

  late AnimationController _radiusController;
  late Animation<double> _radiusAnimation;

  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _sidesController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _sidesAnimation = IntTween(begin: 3, end: 10).animate(_sidesController);

    _radiusController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _radiusAnimation = Tween(begin: 20.0, end: 400.0)
        .chain(CurveTween(curve: Curves.bounceInOut))
        .animate(_sidesController);

    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _rotationAnimation = Tween(begin: 0.0, end: 2 * pi)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_rotationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sidesController.repeat(reverse: true);
    _radiusController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _sidesController.dispose();
    _radiusController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge(
              [_sidesController, _radiusController, _rotationController]),
          builder: (context, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(_rotationAnimation.value)
              ..rotateY(_rotationAnimation.value)
              ..rotateZ(_rotationAnimation.value),
            child: CustomPaint(
              painter: Polygon(sides: _sidesAnimation.value),
              child: SizedBox(
                width: _radiusAnimation.value,
                height: _radiusAnimation.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Polygon extends CustomPainter {
  final int sides;

  Polygon({required this.sides});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final path = Path();

    final center = Offset(size.width / 2, size.height / 2);

    // For 3 sides : 360/3 = 120 degrees
    final angle = (2 * pi) / sides;

    //For 3 sides: index * angle = [0*120, 1*120, 2*120] = [0,120,240] (in degrees)
    final angles = List.generate(sides, (index) => index * angle);

    final radius = size.width / 2;

    /* 
    TO get the points at which the angles list intercepts the circle, for the different axes we make use of:

    x = center.x + radius * cos(angle)
    y = center.y + radius * sin(angle)
     */

    //this marks the first point where paint begins drawing a path
    path.moveTo(center.dx + radius * cos(0), center.dx + radius * sin(0));

    //next we draw the lines that join the points
    for (final angle in angles) {
      path.lineTo(
          center.dx + radius * cos(angle), center.dy + radius * sin(angle));
    }

//this ensures the painter returns back to its original position from its current position
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is Polygon && oldDelegate.sides != sides;
  }
}
