import 'package:flutter/material.dart';

class UncoverButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const UncoverButton({
    super.key,
    required this.onTap,
    this.text = "UNCOVER",
  });

  @override
  State<UncoverButton> createState() => _UncoverButtonState();
}

class _UncoverButtonState extends State<UncoverButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 64,
        width: double.infinity,
        transform: Matrix4.identity()
          ..scale(_pressed ? 0.97 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFB30000),
              Color(0xFFE53935),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Color(0xFFFFD700), // gold border
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.6),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Glow circle (press point look)
            Positioned(
              left: 24,
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.amberAccent,
                      Colors.amber.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),

            /// Button Text
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
