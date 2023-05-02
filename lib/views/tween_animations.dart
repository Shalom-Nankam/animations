import 'dart:math';

import 'package:flutter/material.dart';

class TweenAnimations extends StatefulWidget {
  const TweenAnimations({super.key});

  @override
  State<TweenAnimations> createState() => _TweenAnimationsState();
}

class _TweenAnimationsState extends State<TweenAnimations> {
  var _color = getRandColor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
            clipper: const CircleClipper(),
            child: TweenAnimationBuilder(
              tween: ColorTween(
                begin: getRandColor(),
                end: _color,
              ),
              onEnd: () {
                //When the animation ends, it changes the color again
                //setstate makes it rebuild the widget
                setState(() {
                  _color = getRandColor();
                });
              },
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return ColorFiltered(
                    colorFilter: ColorFilter.mode(value!, BlendMode.srcATop),
                    //returns the widget described by the child widget
                    //that is the container below
                    child: child);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                color: Colors.red,
              ),
            )),
      ),
    );
  }
}

//A function to generate random colors
Color getRandColor() => Color(0xff000000 + Random().nextInt(0x00ffffff));

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper();
  @override
  Path getClip(Size size) {
    var path = Path();

//We are creating a rect from a circle measurement i.e a rectangle that contains the circle
    final rect = Rect.fromCircle(
        //the center of the circle location
        center: Offset(size.width / 2, size.height / 2),
        //the radius of the circle
        radius: size.width / 2);

    path.addOval(rect);

    return path;
  }

//this determines if the shape should be redrawn after its size changes
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
