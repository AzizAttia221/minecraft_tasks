import 'package:flutter/material.dart';

class MinecraftBackground extends StatelessWidget {
  final Widget child;

  const MinecraftBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Container(
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        // ignore: prefer_const_constructors
        image: DecorationImage(
          image: const AssetImage(
            'assets/garden_awakens.png',
          ),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(
            Color.fromRGBO(0, 0, 0, 0.65),
            BlendMode.darken,
          ),
        ),
      ),
      // ignore: prefer_const_constructors
      child: Container(
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 0, 0, 0.65),
              Color.fromRGBO(0, 0, 0, 0.48),
              Color.fromRGBO(0, 0, 0, 0.75),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}