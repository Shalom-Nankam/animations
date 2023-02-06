import 'package:flutter/material.dart';

class ChainedAnimationsPage extends StatefulWidget {
  const ChainedAnimationsPage({super.key});

  @override
  State<ChainedAnimationsPage> createState() => _ChainedAnimationsPageState();
}

class _ChainedAnimationsPageState extends State<ChainedAnimationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [],
          ),
        ),
      ),
    );
  }
}
