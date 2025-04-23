import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFF6A11CB), // Ungu tua
      Color(0xFF2575FC), // Biru muda
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Pastikan mengisi seluruh layar
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          stops: [0.0, 1.0], // Titik transisi
        ),
      ),
      child: child,
    );
  }
}
