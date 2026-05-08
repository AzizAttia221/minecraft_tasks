import 'package:flutter/material.dart';

class MinecraftButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const MinecraftButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? const Color(0xFF3DBB4F);
    final gradientTop = color == null ? const Color.fromRGBO(61, 187, 79, 0.98) : baseColor;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.35),
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              gradientTop,
              baseColor,
            ],
          ),
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.6,
          ),
        ),
      ),
    );
  }
}