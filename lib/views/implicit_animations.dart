import 'package:flutter/material.dart';

class ImplicitAnimation extends StatefulWidget {
  const ImplicitAnimation({super.key});

  @override
  State<ImplicitAnimation> createState() => _ImplicitAnimationState();
}

double defaultWidth = 100.0;

class _ImplicitAnimationState extends State<ImplicitAnimation> {
  bool isZoomedIn = false;
  String buttonTitle = 'Zoom in';
  double imageWidth = defaultWidth;
  Curve animationCurve = Curves.easeOut;

  void animate() {
    setState(() {
      isZoomedIn = !isZoomedIn;
      buttonTitle = isZoomedIn ? 'Zoom out' : 'Zoom in';
      imageWidth =
          isZoomedIn ? MediaQuery.of(context).size.width : defaultWidth;
      animationCurve = isZoomedIn ? Curves.easeOut : Curves.easeIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 360),
                  curve: animationCurve,
                  width: imageWidth,
                  child: Image.asset('assets/images/screen.png'),
                ),
              ],
            ),
            TextButton(onPressed: () => animate(), child: Text(buttonTitle))
          ],
        )),
      ),
    );
  }
}
