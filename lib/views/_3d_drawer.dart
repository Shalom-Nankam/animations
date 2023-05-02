import 'dart:math';

import 'package:flutter/material.dart';

class ThreeDimensionDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;

  const ThreeDimensionDrawer(
      {super.key, required this.child, required this.drawer});

  @override
  State<ThreeDimensionDrawer> createState() => _ThreeDimensionDrawerState();
}

class _ThreeDimensionDrawerState extends State<ThreeDimensionDrawer>
    with TickerProviderStateMixin {
  late AnimationController _xAnimationControllerForChild;
  late Animation<double> _yRotationAnimationForChild;

  late AnimationController _xAnimationControllerForDrawer;
  late Animation<double> _yRotationAnimationForDrawer;

  @override
  void initState() {
    super.initState();

    _xAnimationControllerForChild = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    //since the child widget rotates inwards into the screen, we make the end value
    //negative
    _yRotationAnimationForChild = Tween<double>(begin: 0.00, end: -pi / 2)
        .animate(_xAnimationControllerForChild);

    _xAnimationControllerForDrawer = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    //starts from outside the screen and ends inside the screen at position 0
    _yRotationAnimationForDrawer = Tween(begin: pi / 2.7, end: 0.0)
        .animate(_xAnimationControllerForDrawer);
  }

  @override
  void dispose() {
    _xAnimationControllerForChild.dispose();
    _xAnimationControllerForDrawer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    //the drawer only occupies about 80% of the total screen width
    final maxDrag = screenWidth * 0.8;
    //Gesture detector handles the drag on the screen
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _xAnimationControllerForChild.value += details.delta.dx / maxDrag;
        _xAnimationControllerForDrawer.value += details.delta.dx / maxDrag;
      },
      onHorizontalDragEnd: (details) {
        if (_xAnimationControllerForChild.value < 0.5) {
          _xAnimationControllerForChild.reverse();
          _xAnimationControllerForDrawer.reverse();
        } else {
          _xAnimationControllerForChild.forward();
          _xAnimationControllerForDrawer.forward();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge(
            [_xAnimationControllerForChild, _xAnimationControllerForDrawer]),
        builder: (context, child) => Stack(
          children: [
            Container(
              color: const Color(0xff1a1b26),
            ),
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translate(_xAnimationControllerForChild.value * maxDrag)
                ..rotateY(_yRotationAnimationForChild.value),
              //we are rotating the child about the center left so we align it that way
              alignment: Alignment.centerLeft,
              child: widget.child,
            ),
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translate(-screenWidth +
                    _xAnimationControllerForDrawer.value * maxDrag)
                ..rotateY(_yRotationAnimationForDrawer.value),
              //we are rotating the drawer about the center right so we align it that way
              alignment: Alignment.centerRight,
              child: widget.drawer,
            ),
          ],
        ),
      ),
    );
  }
}

class ThreeDimensionHome extends StatefulWidget {
  const ThreeDimensionHome({super.key});

  @override
  State<ThreeDimensionHome> createState() => _ThreeDimensionHomeState();
}

class _ThreeDimensionHomeState extends State<ThreeDimensionHome> {
  @override
  Widget build(BuildContext context) {
    return ThreeDimensionDrawer(
        drawer: Material(
          child: Container(
            color: const Color(0xff24283b),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 100, left: 100),
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(
                title: Text(' Item $index'),
              ),
            ),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Child Page'),
          ),
          body: Container(
            color: const Color(0xff414868),
          ),
        ));
  }
}
