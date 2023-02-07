import 'package:flutter/material.dart';

class ChainedAnimationsPage extends StatefulWidget {
  const ChainedAnimationsPage({super.key});

  @override
  State<ChainedAnimationsPage> createState() => _ChainedAnimationsPageState();
}

class _ChainedAnimationsPageState extends State<ChainedAnimationsPage> {
  final double middle = 75.0;
  @override
  Widget build(BuildContext context) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    color: Colors.purple,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    color: Colors.blue,
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.brown),
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
