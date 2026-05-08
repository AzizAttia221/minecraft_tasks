import 'package:flutter/material.dart';

class MinecraftBackground extends StatelessWidget {
  final Widget child;

  const MinecraftBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/garden_awakens.png',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            const Color.fromRGBO(0, 0, 0, 0.65),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
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