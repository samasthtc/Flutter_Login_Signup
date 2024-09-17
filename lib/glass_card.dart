import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class GlassCard extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final BoxShape shape;
  const GlassCard({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: height,
      width: width,
      shape: shape,
      blur: 12,
      opacity: 0.6,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.5),
          Colors.white.withOpacity(0.1),
        ],
      ),
      border: Border.all(
        color: Colors.white.withOpacity(0.3),
      ),
      shadowStrength: 5,
      borderRadius: shape == BoxShape.rectangle
          ? BorderRadius.circular(20)
          : BorderRadius.circular(200),
      shadowColor: Colors.black.withOpacity(0.3),
      child: child,
    );
  }
}
