import 'package:flutter/material.dart';

class SayMiraLoader extends StatefulWidget {
  const SayMiraLoader({super.key});

  @override
  State<SayMiraLoader> createState() => _SayMiraLoaderState();
}

class _SayMiraLoaderState extends State<SayMiraLoader>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // infinite rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _controller,
        child: Image.asset(
          "assets/images/say_mira_logo.jpeg",
          width: 120,
        ),
      ),
    );
  }
}
